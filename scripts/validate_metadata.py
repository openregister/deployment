"""
The registry-data github repository is the source of data stored in the
"register" register.
That repository also contains additional metadata such as friendly register names, which
get stored as system entries in the individual registers.

This script ensures that this data actually reflects whats stored in the registers themselves

Usage: GITHUB_OAUTH_TOKEN=<github personal access token> python validate_metadata.py
"""
import requests
import yaml
import sys
from base64 import b64decode
from rsflib.remote import fetch
from os import environ

OAUTH_TOKEN = environ.get('GITHUB_OAUTH_TOKEN')

headers = {
    'User-Agent': 'openregister/deployment',
    'Authorization': f'token {OAUTH_TOKEN}'
}

class Result():
    def __init__(self, name):
        self.name = name
        self.errors = []

    def fail(self, register, github):
        self.errors.append((register, github))

    def report(self):
        print('-'*10)

        if self.errors:
            print(f'{name} ❌')

            for register, github in self.errors:
                print()
                print(f'Register has {register}')
                print(f'Github has {github}')
        else:
            print(f'{name} ✅')

        print('-'*10)
        print()


CONTENT_ENDPOINT = 'https://api.github.com/repos/openregister/registry-data/contents'

if __name__ == '__main__':
    registers = requests.get(CONTENT_ENDPOINT + '/data/beta/register', headers=headers)
    total_errors = 0

    if registers.status_code != 200:
        print(registers.status_code)
        print(registers.json())
        sys.exit(1)

    for item in registers.json():
        name = item['name'].replace('.yaml', '')
        path = item['path']
        result = Result(name)

        register_rsf = fetch(name)

        response = requests.get(CONTENT_ENDPOINT + '/' + path, headers=headers).json()

        try:
            register_record = yaml.load(b64decode(response['content']))
        except Exception:
            print('unable to load registry record')
            print(response)
            sys.exit(1)

        response = requests.get(CONTENT_ENDPOINT + f'/data/beta/{name}/meta.yaml', headers=headers)
        if response.status_code == 404:
            print(f'404 for data/beta/{name}/meta.yaml')
            friendly_name = None
        else:
            try:
                meta = yaml.load(b64decode(response.json()['content']))
            except Exception:
                print('Unable to load meta')
                print(response)

            try:
                friendly_name = meta['register-name']
            except Exception:
                print(f'Unable to parse meta file: {response.json()}')
                friendly_name = None

        if register_rsf.register_record != register_record:
            # Ensure register register is consistent with the register
            result.fail(register=register_rsf.register_record, github=register_record)

        if register_rsf.friendly_name != friendly_name:
            # Ensure friendly name metadata is consistent with the register
            result.fail(register=register_rsf.friendly_name, github=friendly_name)
        elif register_rsf.friendly_name is None and friendly_name is None:
            # Ensure a friendly name is set
            result.fail(register=register_rsf.friendly_name, github=friendly_name)

        result.report()
        total_errors += len(result.errors)

    if total_errors:
        print(f'Found {total_errors} errors')
        sys.exit(1)
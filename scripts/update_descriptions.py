import requests
import sys
import hashlib
import re
import json
import datetime

def sha256(value):
    m = hashlib.sha256()
    m.update(value)
    return m.hexdigest()

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('Usage: ... <register> <old_description> <new_description>', file=sys.stderr)
        sys.exit(1)
    register = sys.argv[1]
    old_desc = sys.argv[2]
    new_desc = sys.argv[3]
    print(f'<{register}> change "{old_desc}" -> "{new_desc}"', file=sys.stderr)

    response = requests.get(f'https://{register}.beta.openregister.org/download-rsf')

    old_item = None
    old_hash = None
    old_add_entry = None
    for line in response.iter_lines():
        match = re.match(rf'^add-item\t(.*{old_desc}.*)'.encode('utf8'), line)
        if match:
            old_item = match.group(1)

            old_hash = sha256(old_item)
            old_item = json.loads(old_item)

    if not old_item:
        print('Failed to find the old item', file=sys.stderr)
        sys.exit(1)

    new_item = old_item.copy()
    new_item['text'] = new_desc
    new_item = json.dumps(new_item, separators=(',', ':'))
    new_hash = sha256(new_item.encode('utf8'))
    print(f'add-item\t{new_item}')

    # example: '2018-02-01T13:30:23Z'
    timestamp = datetime.datetime.utcnow().isoformat(timespec='seconds')
    print(f'append-entry\tsystem\tregister:{register}\t{timestamp}Z\tsha-256:{new_hash}')
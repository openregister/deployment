import requests
import sys
import hashlib
import re
import json
import datetime
from enum import Enum


ITEM_REGEX = re.compile(r'^add-item\t({[^}]+})$')
ENTRY_REGEX = re.compile(r'^append-entry\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)$')


class RsfCommand(Enum):
    ADD_ITEM = 'add-item'
    APPEND_ENTRY = 'append-entry'


def parse_rsf_line(line):
    match = ITEM_REGEX.match(line)
    if match:
        item = match.group(1)
        item = json.loads(item)
        return RsfAddItem(item)

    match = ENTRY_REGEX.match(line)
    if match:
        entry_type = match.group(1)
        key = match.group(2)
        timestamp = match.group(3)
        item_hash = match.group(4)
        return RsfAppendEntry(key=key, item_hash=item_hash, timestamp=timestamp, entry_type=entry_type)

    return None


def find_register_item(register_name, lines):
    """
    Find an item with key register:{register_name}
    """
    items = {}
    most_recent_item = None

    for line in lines:
        rsf = parse_rsf_line(line.decode('utf8'))
        if not rsf:
            continue

        if rsf.command == RsfCommand.ADD_ITEM:
            items[rsf.item_hash()] = rsf

        elif rsf.command == RsfCommand.APPEND_ENTRY and rsf.key == f'register:{register_name}':
            most_recent_item = rsf.item_hash

    if most_recent_item:
         return items[most_recent_item]

    return None


class RsfAddItem:
    def __init__(self, item):
        self.item = item
        self.command = RsfCommand.ADD_ITEM

    def item_hash(self):
        m = hashlib.sha256()
        m.update(self.item_json().encode('utf8'))
        return f'sha-256:{m.hexdigest()}'

    def item_json(self):
        return json.dumps(self.item, separators=(',', ':'))

    def __str__(self):
        return f'add-item\t{self.item_json()}'


class RsfAppendEntry:
    def __init__(self, key, item_hash, timestamp=None, entry_type='system'):
        self.entry_type = entry_type

        # example: '2018-02-01T13:30:23Z'
        self.timestamp = timestamp or datetime.datetime.utcnow().isoformat(timespec='seconds')
        self.key = key
        self.item_hash = item_hash
        self.command = RsfCommand.APPEND_ENTRY

    def __str__(self):
        return f'append-entry\t{self.entry_type}\t{self.key}\t{self.timestamp}Z\t{self.item_hash}'


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Usage: ... <register> <new_description>', file=sys.stderr)
        sys.exit(1)
    register = sys.argv[1]
    new_desc = sys.argv[2]

    response = requests.get(f'https://{register}.beta.openregister.org/download-rsf')

    item = find_register_item(register, response.iter_lines())
    if not item:
        print('Failed to find the old item', file=sys.stderr)
        sys.exit(1)

    item.item['text'] = new_desc
    print(item)

    new_entry = RsfAppendEntry(key=f'register:{register}', item_hash=item.item_hash())
    print(new_entry)
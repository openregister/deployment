import datetime
import hashlib
import json
from enum import Enum


class RsfCommand(Enum):
    ADD_ITEM = 'add-item'
    APPEND_ENTRY = 'append-entry'


class RsfAddItem:
    """
    An RSF add-item command
    """
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
    """
    An RSF append-entry command
    """
    def __init__(self, key, item_hash, timestamp=None, entry_type='system'):
        self.entry_type = entry_type

        # example: '2018-02-01T13:30:23Z'
        self.timestamp = timestamp or datetime.datetime.utcnow().isoformat(timespec='seconds') + 'Z'
        self.key = key
        self.item_hash = item_hash
        self.command = RsfCommand.APPEND_ENTRY

    def __str__(self):
        return f'append-entry\t{self.entry_type}\t{self.key}\t{self.timestamp}\t{self.item_hash}'

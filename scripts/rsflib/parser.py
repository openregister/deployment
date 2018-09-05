import json
import re
from rsflib.rsf import RsfCommand, RsfAddItem, RsfAppendEntry


ITEM_REGEX = re.compile(r'^add-item\t({[^\t]*})$')
ENTRY_REGEX = re.compile(r'^append-entry\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)$')


def parse_rsf_line(line):
    """
    Parse an RSF line into an RsfAddItem or RsfAppendEntry object
    """
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

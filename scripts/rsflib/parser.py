import json
import re
import warnings
from rsflib.rsf import RsfCommand, RsfAddItem, RsfAppendEntry


ITEM_REGEX = re.compile(r'^add-item\t({[^\t]*})$')
ENTRY_REGEX = re.compile(r'^append-entry\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)$')


class RsfFile:
    """
    A parsed RSF file
    """
    def __init__(self, register_name, lines):
        """
        Parse an RSF file into commands.
        register_name is the internal ID of the register.
        lines should contain byte strings.
        """
        self.lines = lines
        self.commands = []
        self.register_name = register_name

        for line in lines:
            parsed_line = parse_rsf_line(line.decode('utf8'))
            if parsed_line is not None:
                self.commands.append(parsed_line)

        self.friendly_name, self.register_record = self._find_metadata()

    def _find_metadata(self):
        """
        Find the register-name and register:{register-id} records
        """
        items = {}
        register_entry = None
        register_name_entry = None

        for rsf in self.commands:
            if rsf.command == RsfCommand.ADD_ITEM:
                items[rsf.item_hash()] = rsf

            elif rsf.command == RsfCommand.APPEND_ENTRY:
                if rsf.key == f'register:{self.register_name}':
                    register_entry = rsf.item_hash
                elif rsf.key == f'register-name':
                    register_name_entry = rsf.item_hash

        register_name_item = items.get(register_name_entry)
        register_record_item = items.get(register_entry)

        return (
            None if register_name_item is None else register_name_item.item['register-name'],
            None if register_record_item is None else register_record_item.item
        )


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
    warnings.warn("Please use the RsfFile class instead of find_register_item", DeprecationWarning)

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

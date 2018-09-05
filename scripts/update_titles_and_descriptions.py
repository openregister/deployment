import requests
import sys
from rsflib.parser import find_register_item
from rsflib.rsf import RsfAppendEntry, RsfAddItem


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('Usage: ... <register> <new_name> <new_description>', file=sys.stderr)
        sys.exit(1)

    register = sys.argv[1]
    new_name = sys.argv[2]
    new_desc = sys.argv[3]

    response = requests.get(f'https://{register}.beta.openregister.org/download-rsf')

    # Update the description inside the register record item
    item = find_register_item(register, response.iter_lines())
    if not item:
        print('Failed to find the old item', file=sys.stderr)
        sys.exit(1)

    item.item['text'] = new_desc
    print(item)

    new_entry = RsfAppendEntry(key=f'register:{register}', item_hash=item.item_hash())
    print(new_entry)

    # Name the register
    name_item = RsfAddItem({'register-name': new_name})
    print(name_item)

    name_entry = RsfAppendEntry(key=f'register-name', item_hash=name_item.item_hash())
    print(name_entry)
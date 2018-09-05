import requests
import sys
from rsflib.parser import find_register_item
from rsflib.rsf import RsfAppendEntry


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
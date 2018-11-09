import rsfcreator
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument('key', help='key to be updated e.g. "custodian"')
parser.add_argument('value', help='value for key e.g. "Jane Doe"')
args = parser.parse_args()

line_map = {args.key: args.value}
item, entry = rsfcreator.rsf_for_line(line_map, args.key, 'system', key = args.key)
print(item + '\n' + entry)
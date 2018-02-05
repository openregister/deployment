from datetime import datetime
import os
import yaml
import csv
import json
import argparse
import hashlib
import requests

def get_register_url(register, phase):
    if phase in ['beta', 'alpha', 'test']:
        return 'https://{0}.{1}.openregister.org'.format(register, phase)
    elif phase == 'discovery':
        return 'https://{0}.cloudapps.digital'.format(register)

def remove_blanks(dic):
    return {k: v for k, v in dic.items() if v }

def replace_for_cardinality(dic, fields_by_name):
    def replace_cardinality_n(field_name, field_value):
        if fields_by_name[field_name]['cardinality'] == 'n' and not isinstance(field_value,list):
            return field_value.split(';')
        else:
            return field_value
    return {k: replace_cardinality_n(k, v) for k, v in dic.items()}

def canonicalize(item, fields_by_name):
    item_tmp = remove_blanks(item)
    return replace_for_cardinality(item_tmp, fields_by_name)

def read_register_from_local(phase, register_name, root_dir):
    file_template = root_dir + '/registry-data/data/{0}/register/{1}.yaml'
    file_name = file_template.format(phase, register_name)
    return read_item_from_local(file_name)

def read_field_from_local(phase, field_name, root_dir):
    field_file_template = root_dir + '/registry-data/data/{0}/field/{1}.yaml'
    file_name = field_file_template.format(phase, field_name)
    return read_item_from_local(file_name)

def read_item_from_local(file_name):
    with open(file_name) as yaml_file:
        dic =  yaml.load(yaml_file)
    return dic

def read_register_from_register(phase, register_name):
    register_url= '{0}/record/{1}.json'.format(get_register_url('register', phase), register_name)
    return read_item_from_register(register_url, register_name)

def read_field_from_register(phase, field_name):
    field_url= '{0}/record/{1}.json'.format(get_register_url('field', phase), field_name)
    return read_item_from_register(field_url, field_name)

def read_item_from_register(url, field_name):
    record_response = requests.get(url)
    record_response.raise_for_status()
    record = record_response.json()
    return record[field_name]['item'][0]

def rsf_for_line(line_dict, key_field, entry_type, key_prefix='', key=None):
    if key is None:
        key = line_dict[key_field]
    timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
    item_str = json.dumps(line_dict, ensure_ascii=False, separators=(',', ':'), sort_keys=True)
    item_hash = hashlib.sha256(item_str.encode("utf-8")).hexdigest()
    item_line = "add-item\t" + item_str
    entry_line = "append-entry\t{0}\t{1}{2}\t{3}\tsha-256:{4}".format(
            entry_type, key_prefix, key, timestamp, item_hash)
    return (item_line, entry_line)

def generate_rsf(args):
    if args.register_data_root:
        register_def = read_register_from_local(args.phase, args.register_name, args.register_data_root)
        field_names = register_def['fields']
        fields_by_name = {fn: read_field_from_local(args.phase, fn, args.register_data_root) for fn in field_names}
    else:
        register_def = read_register_from_register(args.phase, args.register_name)
        field_names = register_def['fields']
        fields_by_name = {fn: read_field_from_register(args.phase, fn) for fn in field_names}
    # for tsv, check first line headings match the register definition
    if args.tsv:
        with open(args.tsv) as csvfile:
            reader = csv.reader(csvfile, delimiter='\t', strict=True)
            field_names_tsv = list( next(reader) )
            if set(field_names_tsv) != set(field_names):
                raise SystemExit('headings in first line of tsv did not match register definition')
    # metadata rsf
    if args.prepend_metadata:
        name_item_line, name_entry_line = rsf_for_line({'name': args.register_name}, 'name', 'system', key='name')
        print(name_item_line + '\n' + name_entry_line)
        if args.custodian:
            custodian_item_line, custodian_entry_line = rsf_for_line({'custodian': args.custodian}, 'custodian', 'system', key='custodian')
            print(custodian_item_line + '\n' + custodian_entry_line)
        for field in fields_by_name.values():
            field_tmp = remove_blanks(field)
            field_item_line, field_entry_line = rsf_for_line(field_tmp, 'field', 'system', key_prefix='field:')
            print(field_item_line + '\n' + field_entry_line)
        register_def_tmp = remove_blanks(register_def)
        reg_item_line, reg_entry_line = rsf_for_line(register_def, 'register', 'system', key_prefix='register:')
        print(reg_item_line + '\n' + reg_entry_line)
    # user data rsf
    if args.tsv:
        with open(args.tsv) as csvfile:
            reader = csv.DictReader(csvfile, delimiter='\t')
            for row in reader:
                item_tmp = canonicalize(row, fields_by_name)
                item_line, entry_line = rsf_for_line(item_tmp, args.register_name, 'user')
                print(item_line + '\n' + entry_line)
    elif args.yaml:
        with open(args.yaml) as yamlfile:
            item = yaml.load(yamlfile)
            item_tmp = canonicalize(item, fields_by_name)
            item_line, entry_line = rsf_for_line(item_tmp, args.register_name, 'user')
            print(item_line + '\n' + entry_line)
    else:
        yaml_files = [name for name in os.listdir(args.yaml_dir) if name.endswith('.yaml')]
        for yaml_file in yaml_files:
            with open(os.path.join(args.yaml_dir, yaml_file)) as yamlfile:
                item = yaml.load(yamlfile)
                item_tmp = canonicalize(item, fields_by_name)
                item_line, entry_line = rsf_for_line(item_tmp, args.register_name, 'user')
                print(item_line + '\n' + entry_line)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("register_name", help="the register name")
    parser.add_argument("phase", help="phase e.g. alpha")
    parser.add_argument("--tsv", help="tsv file containing data for register to be loaded")
    parser.add_argument("--yaml", help="yaml file containing field or register data to be loaded")
    parser.add_argument("--yaml_dir", help="directory containing register data in seperate yaml files")
    parser.add_argument("--prepend_metadata", help="prepend field and register definitions", action="store_true")
    parser.add_argument("--register_data_root", help="the directory where register data is checked out")
    parser.add_argument("--custodian", help="the name of the custodian if any")
    args = parser.parse_args()

    generate_rsf(args)

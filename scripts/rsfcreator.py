from datetime import datetime
import yaml
import csv
import json
import argparse
import hashlib
import requests

def remove_blanks(d):
    return {k: v for k, v in d.items() if v } 

def replace_for_cardinality(item, fields_by_name):
    def replace_cardinality_n(field_name, field_value):
        if fields_by_name[field_name]['cardinality'] == 'n':
            return field_value.split(';')
        else:
            return field_value
    return {k: replace_cardinality_n(k, v) for k, v in item.items()}
        
def canonicalize(item, fields_by_name):
    item_tmp = remove_blanks(item)
    return replace_for_cardinality(item_tmp, fields_by_name)

def read_register_from_local(environment, regsiter_name, root_dir):
    file_template = root_dir + '/registry-data/data/{0}/register/{1}.yaml'
    file_name = file_template.format(environment, register_name)
    return read_item_from_local(file_name)

def read_field_from_local(environment, field_name, root_dir):
    field_file_template = root_dir + '/registry-data/data/{0}/field/{1}.yaml'
    file_name = field_file_template.format(environment, field_name)
    return read_item_from_local(file_name)

def read_item_from_local(file_name):
    with open(file_name) as yaml_file:
        d =  yaml.load(yaml_file)
    return d

def read_register_from_register(environment, register_name):
    register_url= 'http://register.{0}.openregister.org/record/{1}.json'.format(environment, register_name)
    return read_item_from_register(register_url)

def read_field_from_register(environment, field_name):
    field_url= 'http://field.{0}.openregister.org/record/{1}.json'.format(environment, field_name)
    return read_item_from_register(field_url)

def read_item_from_register(url):
    field_record_response = requests.get(url)
    field_record_response.raise_for_status()
    field_record = field_record_response.json()  
    return field_record[field_name]['item'][0] 

def rsf_for_line(line_dict, key_field, entry_type, key_prefix=''):
    key = line_dict[key_field]
    timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
    item_str = json.dumps(line_dict, separators=(',', ':'), sort_keys=True)
    item_hash = hashlib.sha256(item_str.encode("utf-8")).hexdigest()
    item_line = "add-item\t" + item_str
    entry_line = "append-entry\t{0}{1}\t{2}\t{3}\tsha-256:{4}".format(
            key_prefix, key, entry_type, timestamp, item_hash)
    return (item_line, entry_line)

def generate_rsf(args):
    # read fields
    if args.tsv:
        with open(args.tsv) as csvfile:
            reader = csv.reader(csvfile, delimiter='\t', strict=True) 
            field_names = list( next(reader) )
    elif args.yaml:
        with open(args.yaml) as yamlfile:
            item = yaml.load(yamlfile)
            field_names = item.keys()
    elif args.yaml_dif:
        pass
    else:
        sys.exit('must specify tsv or yaml file/directory')
    if args.register_data_root:
        fields_by_name = {fn: read_field_from_local(args.env, fn, args.register_data_root) for fn in field_names}
        register_def = read_register_from_local(args.env, fn, args.register_data_root)
    else:
        fields_by_name = {fn: read_field_from_register(args.env, fn) for fn in field_names}
        register_def = read_register_from_register(args.env, args.register_name)
    # metadata rsf
    if args.prepend_metadata:
        for field in fields_by_name.values():
            field_item_line, field_entry_line = rsf_for_line(field, 'field', 'system', key_prefix='field:')
            print(field_item_line + '\n' + field_entry_line)
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
        with open(args.yaml_dir) as yaml_dir:
            for f in dir.files:
                with open(args.yaml) as yamlfile:
                    item = yaml.load(yamlfile)
                    item_tmp = canonicalize(item, fields_by_name)
                    item_line, entry_line = rsf_for_line(item_tmp, args.register_name, 'user')
                    print(item_line + '\n' + entry_line)


            

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("register_name", help="the register name")
    parser.add_argument("env", help="environment e.g. alpha")
    parser.add_argument("--tsv", help="tsv file containing data for register to be loaded")
    parser.add_argument("--yaml", help="yaml file containing field or register data to be loaded")
    parser.add_argument("--prepend_metadata", help="prepend field and register definitions", action="store_true")
    parser.add_argument("--register_data_root", help="the directory where register data is checked out")
    args = parser.parse_args()

    generate_rsf(args)

import unittest
import rsfcreator
import types
import re
from io import StringIO
from unittest.mock import patch

def strip_date(s):
    return re.sub(r'20\d+-\d+-\d+T\d+:\d+:\d+Z', '2000-00-00T00:00:00Z', s)

class TestRsfCreator(unittest.TestCase):

    def test_should_order_fields_and_output_no_whitespace(self):
        line_map = {'notifiable-animal-disease':'WARBLE', 'name':'Warble Fly', 'notifiable-locations':'Scotland','notifiable-animal-disease-investigation-category':'WARBLE','notifiable-animal-disease-confirmation-category':'WARFLY'}
        item_line, entry_line = rsfcreator.rsf_for_line( line_map, 'notifiable-animal-disease', 'user')
        expected = 'add-item\t{"name":"Warble Fly","notifiable-animal-disease":"WARBLE","notifiable-animal-disease-confirmation-category":"WARFLY","notifiable-animal-disease-investigation-category":"WARBLE","notifiable-locations":"Scotland"}'
        self.assertEqual(item_line, expected)

    def test_should_format_entry_line(self):
        line_map = {'notifiable-animal-disease':'WARBLE', 'name':'Warble Fly', 'notifiable-locations':'Scotland','notifiable-animal-disease-investigation-category':'WARBLE','notifiable-animal-disease-confirmation-category':'WARFLY'}
        item_line, entry_line = rsfcreator.rsf_for_line( line_map, 'notifiable-animal-disease', 'user')
        expected = 'append-entry\tuser\tWARBLE\t\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\tsha-256:5ea5f947be468b201c2f4803e54f6a812fed5ecbeaf4053eac39139b44cd55bb'
        match = re.fullmatch(expected, entry_line)
        self.assertIsNotNone(match)

    def test_should_remove_blank_fields(self):
        line_map = {'a':'b','c':'','d':None}
        expected = {"a":"b"}
        deblanked = rsfcreator.remove_blanks(line_map)
        self.assertEqual(deblanked, expected)

    def test_should_convert_single_field_to_list_for_cardinality_n(self):
        line_map = {'a':'b','c':'d'}
        expected = {"a":"b","c":["d"]}
        field_a = {'cardinality':'1'}
        field_c = {'cardinality':'n'}
        fields_by_name = {'a': field_a, 'c': field_c}
        converted = rsfcreator.replace_for_cardinality(line_map, fields_by_name)
        self.assertEqual(converted, expected)

    def test_should_convert_semicolon_delimited_to_list_for_cardinality_n(self):
        line_map = {'a':'b','c':'d;e;f'}
        expected = {"a":"b","c":["d","e","f"]}
        field_a = {'cardinality':'1'}
        field_c = {'cardinality':'n'}
        fields_by_name = {'a': field_a, 'c': field_c}
        converted = rsfcreator.replace_for_cardinality(line_map, fields_by_name)
        self.assertEqual(converted, expected)
    
    def test_should_fail_if_column_headings_wrong(self):
        args = types.SimpleNamespace(register_name='notifiable-animal-disease', tsv='test-data/wrong-headings.tsv',
                register_data_root='test-data', prepend_metadata=False, phase='alpha')
        with self.assertRaises(SystemExit):
            rsfcreator.generate_rsf(args)

    def test_should_fail_if_column_headings_missing(self):
        args = types.SimpleNamespace(register_name='notifiable-animal-disease', tsv='test-data/headings-missing.tsv', 
                register_data_root='test-data', prepend_metadata=False, phase='alpha')
        with self.assertRaises(SystemExit):
            rsfcreator.generate_rsf(args)

    def test_should_handle_commas_quotes(self):
        "to understand the python cvs parser"
        args = types.SimpleNamespace(register_name='notifiable-animal-disease', tsv='test-data/commas-quotes.tsv', 
                register_data_root='test-data', include_user_data=True, prepend_metadata=False, phase='alpha')
        with patch('sys.stdout', new=StringIO()) as fake_out:
            rsfcreator.generate_rsf(args)

    def test_should_not_encode_special_characters_as_unicode(self):
        line_map = {'notifiable-animal-disease':'WARBLE', 'name':'Wârble Fly', 'notifiable-locations':'Scôtland','notifiable-animal-disease-investigation-category':'WARBLE','notifiable-animal-disease-confirmation-category':'WARFLY'}
        item_line, entry_line = rsfcreator.rsf_for_line( line_map, 'notifiable-animal-disease', 'user')
        expected = 'add-item\t{"name":"Wârble Fly","notifiable-animal-disease":"WARBLE","notifiable-animal-disease-confirmation-category":"WARFLY","notifiable-animal-disease-investigation-category":"WARBLE","notifiable-locations":"Scôtland"}'
        self.assertEqual(item_line, expected)

    def test_should_load_yaml_file(self):
        args = types.SimpleNamespace(register_name='field',
                tsv=None, yaml='test-data/registry-data/data/alpha/field/notifiable-animal-disease.yaml',
                register_data_root='test-data', prepend_metadata=False, include_user_data=True,
                phase='alpha', custodian='Foo Bar')
        with open('test-data/expected/register-update.rsf','r') as rsf_file:
            expected_rsf = rsf_file.read()
        with patch('sys.stdout', new=StringIO()) as patched_out:
            rsfcreator.generate_rsf(args)
            rsf_no_date  = strip_date(patched_out.getvalue())
            self.assertEqual(expected_rsf, rsf_no_date)

    def test_should_load_yaml_dir(self):
        args = types.SimpleNamespace(register_name='register',
                tsv=None, yaml=None,
                yaml_dir='test-data/registry-data/data/alpha/register',
                register_data_root='test-data', prepend_metadata=True,
                include_user_data=True, phase='alpha', custodian=None)
        with open('test-data/expected/register-register.rsf','r') as rsf_file:
            expected_rsf = rsf_file.readlines()
        with patch('sys.stdout', new=StringIO()) as patched_out:
            rsfcreator.generate_rsf(args)
            rsf_no_date  = strip_date(patched_out.getvalue())
            for line in expected_rsf:
                self.assertIn(line, rsf_no_date, msg=line + ' was not in rsf')

    def test_should_load_fields_yaml_dir(self):
        args = types.SimpleNamespace(register_name='field',
                tsv=None, yaml=None,
                yaml_dir='test-data/registry-data/data/alpha/field',
                register_data_root='test-data', prepend_metadata=True,
                include_user_data=True, phase='alpha', custodian=None)
        with open('test-data/expected/field-register.rsf','r') as rsf_file:
            expected_rsf = rsf_file.readlines()
        with patch('sys.stdout', new=StringIO()) as patched_out:
            rsfcreator.generate_rsf(args)
            rsf_no_date  = strip_date(patched_out.getvalue())
            for line in expected_rsf:
                 self.assertIn(line, rsf_no_date, msg=line + ' was not in rsf')

    def test_should_include_name_custodian(self):
        args = types.SimpleNamespace(register_name='notifiable-animal-disease',
                tsv='test-data/notifiable-animal-disease.tsv',
                register_data_root='test-data', prepend_metadata=True,
                include_user_data=True, phase='alpha', custodian='Foo Bar')
        with open('test-data/expected/animal-diseases.rsf','r') as rsf_file:
            expected_rsf = rsf_file.readlines()
        with patch('sys.stdout', new=StringIO()) as patched_out:
            rsfcreator.generate_rsf(args)
            rsf_no_date  = strip_date(patched_out.getvalue())
            for line in expected_rsf:
                 self.assertIn(line, rsf_no_date, msg=line + ' was not in rsf')


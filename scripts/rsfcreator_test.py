import unittest
import rsfcreator
import types
import re
from io import StringIO
from unittest.mock import patch

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

    def test_should_fail_if_column_headings_missing(self):
        args = types.SimpleNamespace(tsv='test-data/headings-missing.tsv', register_data_root='test-data', prepend_metadata=False, env='alpha')
        with self.assertRaises(FileNotFoundError):
            rsfcreator.generate_rsf(args)

    def test_should_handle_commas_quotes(self):
        "to understand the python cvs parser"
        args = types.SimpleNamespace(register_name='notifiable-animal-disease', tsv='test-data/commas-quotes.tsv', register_data_root='test-data', prepend_metadata=False, env='alpha')
        with patch('sys.stdout', new=StringIO()) as fake_out:
            rsfcreator.generate_rsf(args)

    def test_should_load_yaml(self):
        args = types.SimpleNamespace(register_name='field',
                tsv=None, yaml='test-data/registry-data/data/alpha/field/notifiable-animal-disease.yaml',
                register_data_root='test-data', prepend_metadata=False, env='alpha')
        with patch('sys.stdout', new=StringIO()) as fake_out:
            rsfcreator.generate_rsf(args)

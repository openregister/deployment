import unittest
from hypothesis import given, example, reproduce_failure, assume
from hypothesis.strategies import text, recursive, booleans, floats, none, lists, dictionaries, datetimes, one_of, just
from string import printable
from .rsf import RsfAddItem, RsfAppendEntry
from .parser import parse_rsf_line, find_register_item, RsfFile

json_values = none() | booleans() | floats() | text(printable)
json_values = json_values | lists(json_values)
flat_json = dictionaries(text(printable), json_values)
not_tabs = printable.replace('\t', '')


class TestRsf(unittest.TestCase):
    @given(flat_json)
    @example({"fields":["country","name","official-name","citizen-names","start-date","end-date"],"phase":"beta","register":"country","registry":"foreign-commonwealth-office","text":"British English-language names and descriptive terms for countries"})
    def test_serialising_and_parsing_items_is_consistent(self, item):
        add_item = RsfAddItem(item)
        rsf = str(add_item)
        parsed = parse_rsf_line(rsf)
        rsf2 = str(parsed)

        self.assertEqual(rsf, rsf2)

    @given(text(not_tabs, min_size=1), text(not_tabs, min_size=1), datetimes(), one_of(just('system'), just('user'), text(not_tabs, min_size=1)))
    def test_serialising_and_parsing_entries_is_consistent(self, key, item_hash, timestamp, entry_type):
        timestamp = timestamp.isoformat(timespec='seconds') + 'Z'
        entry = RsfAppendEntry(key, item_hash, timestamp, entry_type)
        rsf = str(entry)
        parsed = parse_rsf_line(rsf)
        rsf2 = str(parsed)

        self.assertEqual(rsf, rsf2)

    def test_invalid_rsf_does_not_parse(self):
        self.assertIsNone(parse_rsf_line(''))
        self.assertIsNone(parse_rsf_line('hello'))
        self.assertIsNone(parse_rsf_line('\t'))

    def test_rsf_file_ignores_invalid_commands(self):
        rsf = [b'', b'\t', b'hello']
        rsf_object = RsfFile('jobcentre-district', rsf)
        self.assertEqual(rsf_object.commands, [])
        self.assertIsNone(rsf_object.register_record)
        self.assertIsNone(rsf_object.friendly_name)

    def test_register_items_are_findable(self):
        rsf = [
            b'add-item	{"fields":["jobcentre-district","name","jobcentre-group","start-date","end-date"],"phase":"beta","register":"jobcentre-district","registry":"department-for-work-pensions","text":"Districts of jobcentre offices in England, Scotland and Wales"}',
            b'append-entry	system	register:jobcentre-district	2018-07-13T09:38:47Z	sha-256:8b2905acc66d55b330213e03b61316dbd74ec3f012722237e0cd3327276d999e',
        ]
        item = find_register_item('jobcentre-district', rsf)
        self.assertEqual(item.item_hash(), 'sha-256:8b2905acc66d55b330213e03b61316dbd74ec3f012722237e0cd3327276d999e')

    def test_item_lookup_is_by_most_recent_entry(self):
        rsf = [
            b'add-item	{"fields":["jobcentre-district","name","jobcentre-group","start-date","end-date"],"phase":"beta","register":"jobcentre-district","registry":"department-for-work-pensions","text":"Districts of jobcentre offices in England, Scotland and Wales"}',
            b'append-entry	system	register:jobcentre-district	2018-07-13T09:38:47Z	sha-256:8b2905acc66d55b330213e03b61316dbd74ec3f012722237e0cd3327276d999e',
            b'add-item	{"fields":["jobcentre-district","name","jobcentre-group","start-date","end-date"],"phase":"beta","register":"jobcentre-district","registry":"department-for-work-pensions","text":"Updated"}',
            b'append-entry	system	register:jobcentre-district	2018-07-13T09:38:47Z	sha-256:f14292b0d801b81ebf625906c996ff3493b71b0e9fbad551e814b10129ab2218',
            b'add-item	{"fields":["jobcentre-district","name","jobcentre-group","start-date","end-date"],"phase":"beta","register":"jobcentre-district","registry":"department-for-work-pensions","text":"No entry"}',
        ]
        rsf_object = RsfFile('jobcentre-district', rsf)
        self.assertEqual(rsf_object.register_record['text'], 'Updated')

    def test_other_keys_are_ignored_in_item_lookup(self):
        rsf = [
            b'add-item	{"fields":["jobcentre-district","name","jobcentre-group","start-date","end-date"],"phase":"beta","register":"jobcentre-district","registry":"department-for-work-pensions","text":"Districts of jobcentre offices in England, Scotland and Wales"}',
            b'append-entry	system	something-else	2018-07-13T09:38:47Z	sha-256:8b2905acc66d55b330213e03b61316dbd74ec3f012722237e0cd3327276d999e',
        ]
        rsf_object = RsfFile('jobcentre-district', rsf)
        self.assertIsNone(rsf_object.register_record)

    def test_register_name_lookup(self):
        rsf = [
            b'add-item	{"fields":["jobcentre-district","name","jobcentre-group","start-date","end-date"],"phase":"beta","register":"jobcentre-district","registry":"department-for-work-pensions","text":"Districts of jobcentre offices in England, Scotland and Wales"}',
            b'append-entry	system	register:jobcentre-district	2018-07-13T09:38:47Z	sha-256:8b2905acc66d55b330213e03b61316dbd74ec3f012722237e0cd3327276d999e',
            b'add-item	{"register-name":"Jobcentre district register"}',
            b'append-entry	system	register-name	2018-07-13T09:38:47Z	sha-256:e93900a7a6acbb8418fbd233284a34271d28217a541725668bf6408c022731a2',
        ]
        rsf_object = RsfFile('jobcentre-district', rsf)
        self.assertEqual(rsf_object.friendly_name, 'Jobcentre district register')
        self.assertEqual(rsf_object.register_record, {"fields":["jobcentre-district","name","jobcentre-group","start-date","end-date"],"phase":"beta","register":"jobcentre-district","registry":"department-for-work-pensions","text":"Districts of jobcentre offices in England, Scotland and Wales"})
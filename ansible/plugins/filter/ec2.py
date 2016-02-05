from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

def normalize_ec2_tags(v=''):
  v = v.replace('-', '_')   # Replace hyphens with underscores
  return v

class FilterModule(object):
  filter_map = {
    'normalize_ec2_tags': normalize_ec2_tags
  }

  def filters(self):
    return self.filter_map

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

def normalize_ec2_tags(v=''):
  v = v.replace('-', '_')   # Replace hyphens with underscores
  return v

def normalize_s3_bucket_name(v=''):
  v= v.replace('.', '-')    # Replace dots with hyphens
  return v

class FilterModule(object):
  filter_map = {
    'normalize_ec2_tags': normalize_ec2_tags,
    'normalize_s3_bucket_name': normalize_s3_bucket_name
  }

  def filters(self):
    return self.filter_map

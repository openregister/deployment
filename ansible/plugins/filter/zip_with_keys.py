def zip_with_keys(values, keys):
    retval = dict(zip(keys, values))
    return retval

class FilterModule(object):
    filter_map = {
      'zip_with_keys': zip_with_keys
		}

    def filters(self):
        return self.filter_map

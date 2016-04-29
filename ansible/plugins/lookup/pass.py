#!/usr/bin/env python

from __future__ import (absolute_import, division, print_function)
from subprocess import check_output
from ansible.plugins.lookup import LookupBase
import os
__metaclass__ = type


class LookupModule(LookupBase):

    def run(self, terms, varibles=None, **kwargs):
        result = []

        env = os.environ.copy()
        env['PASSWORD_STORE_DIR'] = '%s/.registers-pass' % os.getenv('HOME')
        for term in terms:
            var = term.split()[0]

            out = check_output("pass " + var, shell=True, env=env).rstrip()
            result.append(out)

        return result

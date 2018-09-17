#!/usr/bin/env python3
'''
This lambda reads CloudFront logs from an S3 bucket, anonymises them, then
writes back to another S3 bucket.

An example log file contains tab-delimited values and starts with a header like:

#Version: 1.0
#Fields: date time x-edge-location sc-bytes c-ip cs-method cs(Host) cs-uri-stem sc-status cs(Referer) cs(User-Agent) cs-uri-query cs(Cookie) x-edge-result-type x-edge-request-id x-host-header cs-protocol cs-bytes time-taken x-forwarded-for ssl-protocol ssl-cipher x-edge-response-result-type cs-protocol-version
'''
import secrets
import hashlib
import boto3
import botocore
import gzip
import io
import logging
from urllib.parse import unquote_plus
from os import environ

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client('s3')

TARGET_BUCKET = environ['TARGET_BUCKET']

class LogCleaner:
    """
    Clean Cloudfront log files

    - Sanitise IP addresses
    - Remove fields we don't care about
    - Ensure columns appear in a defined order regardless of log version
    """
    def __init__(self, filename):
        self.filename = filename
        self.random_salt = secrets.token_bytes(32)
        self.input_fields = []

        # The output file drops some columns and should have a fixed order even if the source log
        # format changes.
        self.output_fields = [
            'date',
            'time',
            'x-edge-location',    # 3 letter code eg DFW3
            'sc-bytes',           # Number of bytes sent from server -> client
            'anonymised-ip',
            'cs-method',          # HTTP method
            'cs-uri-stem',        # Path part of the URL
            'sc-status',          # HTTP response code
            'cs-uri-query',       # Query string part of the URL, or a hyphen (-)
            'x-host-header',      # The host header
            'cs-protocol',        # http or https
            'cs-bytes',           # Number of bytes sent from client -> server
            'time-taken',         # Number of seconds between receiving request and serving last byte of response
            'ssl-protocol',       # If https, the protocol used
            'ssl-cipher',         # If https, the cipher used
            'cs-protocol-version' # HTTP protocol version
        ]

    def anonymised_ip(self, row):
        """
        It should not be possible to identify an IP address (personal data).
        But it should be possible to group requests from the same source, so within
        each log file, assign a random ID
        """
        forwarded = row.get('x-forwarded-for')
        ip = row.get('c-ip')
        components = [i.encode('utf8') for i in (forwarded, ip) if i]
        if not components:
            return b''

        secret = b''.join(components) + self.random_salt
        m = hashlib.sha256()
        m.update(secret)
        return self.filename + '-' + m.hexdigest()

    def parse_header(self, line):
        """
        Parse the header comment that lists the field in this log file, and
        generate a corresponding comment for the output file.
        """
        if not line.startswith('#Fields: '):
            raise ValueError('Unable to parse header: ' + line)

        self.input_fields = line.replace('#Fields: ', '').split(' ')

        return '#Fields: ' + '\t'.join(self.output_fields)

    def parse_line(self, line):
        """
        Map an input log line to an output log line
        """
        values = line.split('\t')
        input_row = dict(zip(self.input_fields, values))
        output_row = []
        for field in self.output_fields:
            if field == 'anonymised-ip':
                value = self.anonymised_ip(input_row)
            else:
                value = input_row[field]
            output_row.append(value)

        return '\t'.join(output_row)

    def parse_file(self, f):
        """
        Iterate over a file-like object and generate the output log file
        """
        yield next(f).strip()
        header = next(f).strip()
        yield self.parse_header(header)
        for line in f:
            yield self.parse_line(line.strip())


class CompressedLogCleaner:
    """
    Wrapper around LogCleaner that operates on gzipped files instead of raw logs
    """
    def __init__(self, filename):
        self.cleaner = LogCleaner(filename)

    def parse_file(self, f):
        # the gzip library doesn't work with streams, so this assumes we can
        # read the whole file into memory
        body = f.read()
        uncompressed = io.StringIO(gzip.decompress(body).decode('utf8'))

        output = '\n'.join(self.cleaner.parse_file(uncompressed))

        return gzip.compress(output.encode('utf8'))


def handler(event, context):
    """
    Lambda function entry point
    """
    record = event['Records'][0]
    record_s3 = record['s3']
    source_bucket = record_s3['bucket']['name']
    source_key = unquote_plus(record_s3['object']['key'])

    if not source_key.endswith('.gz'):
        logger.info('File is not gzipped, aborting')
        return

    cleaner = CompressedLogCleaner(source_key)

    try:
        logger.info(f'Fetching {source_key} from bucket {source_bucket}')
        response = s3.get_object(Bucket=source_bucket, Key=source_key)
    except botocore.exceptions.ClientError as e:
        print(e.response['Error'])
        raise

    body = response['Body']
    cleaned_body = cleaner.parse_file(body)

    #logger.info(repr(cleaned_body))

    try:
        logger.info(f'Writing {len(cleaned_body)} bytes to {source_key} in bucket {TARGET_BUCKET}')
        response = s3.put_object(Bucket=TARGET_BUCKET, Key=source_key, Body=cleaned_body)
    except botocore.exceptions.ClientError as e:
        logger.info(e.response['Error'])
        raise


if __name__ == '__main__':
    # Test the data cleaning part
    import sys

    cleaner = LogCleaner('test')

    for line in cleaner.parse_file(sys.stdin):
        print(line)
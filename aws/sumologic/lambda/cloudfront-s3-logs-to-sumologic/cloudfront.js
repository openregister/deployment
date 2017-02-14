// Copyright 2015, Sumo Logic Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
// Modifications copyright (C) 2016 Crown Copyright (Government Digital Service)

var AWS = require('aws-sdk'),
    zlib = require('zlib'),
    LineStream = require('byline').LineStream,
    through = require('through'),
    request = require('request'),
    ip = require('ip');

var totalLogs = 0;

var HASH_ASCII_CODE = 35;

function filterComments() {
  return through(function write(data) {
    if (data[0] === HASH_ASCII_CODE) {
      return;
    }

    this.queue(data);
  });
}

function anonymize() { 
  return through(function write(data) {
    function anonymizeIp(field) {
      if (ip.isV4Format(field)) {
        return ip.mask(field, "255.255.255.0");
      }

      return "-";
    }

    function anonymizeXForwardedFor(field) {
      return "-";
    }

    var s = data.toString();
    var fields = s.split('\t');

    fields[4] = anonymizeIp(fields[4]);
    fields[19] = anonymizeXForwardedFor(fields[19]);
    this.queue(fields.join('\t') + '\n');
    totalLogs++;
  });
}

function s3LogsToSumo(bucket, objKey, s3, callback) {
    var s3Stream = s3.getObject({
      Bucket: bucket,
      Key: objKey
    }).createReadStream();

    s3Stream.on('error', callback);

    var isCompressed = !!objKey.match(/\.gz$/);
    if (isCompressed) {
        s3Stream = s3Stream.pipe(zlib.createGunzip());
    }

    s3Stream
        .pipe(new LineStream())
        .pipe(filterComments())
        .pipe(anonymize())
        .pipe(request.post('https://endpoint1.collection.eu.sumologic.com/receiver/v1/http/<XXXX>'))
        .on('response', function(response) {
          console.log(response.statusCode);
          console.log('Total logs sent: ' +  totalLogs);
          if (response.statusCode !== 200) {
            return callback('status code: ' + response.statusCode);
          }

          callback();
        })
        .on('error', callback);
}

exports.handler = function(event, context, callback) {
    console.log('Received event: ', JSON.stringify(event, null, 2));

    var s3 = new AWS.S3();

    event.Records.forEach(function(record) {
        var bucket = record.s3.bucket.name;
        var objKey = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
        console.log('Bucket: ' + bucket + ' ObjectKey: ' + objKey);
        s3LogsToSumo(bucket, objKey, s3, callback);
    });
};

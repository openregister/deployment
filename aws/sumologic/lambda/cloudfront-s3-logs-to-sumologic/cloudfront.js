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
    https = require('https'),
    zlib = require('zlib'),
    byline = require('byline'),
    LineStream = require('byline').LineStream,
    ip = require('ip');

var HASH_ASCII_CODE = 35;

var options = {
    'hostname': 'endpoint1.collection.eu.sumologic.com',
    'path': "/receiver/v1/http/<XXXX>",
    'method': 'POST'
};

function anonymizeIp(field) {
    if (ip.isV4Format(field)) {
        return ip.mask(field, "255.255.255.0");
    }

    return "-";
}

function anonymizeXForwardedFor(field) {
    return "-";
}

function anonymize(line) {
    var s = line.toString();
    var fields = s.split('\t');

    fields[4] = anonymizeIp(fields[4]);
    fields[19] = anonymizeXForwardedFor(fields[19]);

    return fields.join('\t');
}

function s3LogsToSumo(bucket, objKey, context, s3) {
    var req = https.request(options, function(res) {
        var body = '';
        console.log('Status: ', res.statusCode);
        res.setEncoding('utf8');
        res.on('data', function(chunk) { body += chunk; });
        res.on('end', function() {
            console.log('Successfully processed HTTPS response');
        });
        res.on('error', function(err) {
            console.log(err);
        });
    });

    var totalLines = 0;

    var s3Stream = s3.getObject({ Bucket: bucket, Key: objKey }).createReadStream();
    s3Stream.on('error', function(error) {
        context.fail(error);
    });

    var isCompressed = !!objKey.match(/\.gz$/);
    if (isCompressed) {
        s3Stream = s3Stream.pipe(zlib.createGunzip());
    }

    s3Stream
        .pipe(new LineStream())
        .on('data', function(data) {
            if (data[0] === HASH_ASCII_CODE) {
                return;
            }

            totalLines++;
            req.write(anonymize(data) + '\n');
        })
        .on('end', function() {
            console.log("End of stream");
            console.log("Log lines processed: " + totalLines);
            req.end();
            context.succeed();
        })
        .on('error', function(error) {
            context.fail(error);
        });
}

exports.handler = function(event, context) {
    console.log('Received event: ', JSON.stringify(event, null, 2));

    var s3 = new AWS.S3();

    options.agent = new https.Agent(options);
    event.Records.forEach(function(record) {
        var bucket = record.s3.bucket.name;
        var objKey = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
        console.log('Bucket: ' + bucket + ' ObjectKey: ' + objKey);
        s3LogsToSumo(bucket, objKey, context, s3);
    });
};

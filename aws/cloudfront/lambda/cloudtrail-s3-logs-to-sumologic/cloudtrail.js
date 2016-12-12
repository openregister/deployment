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
    zlib = require('zlib');

var options = {
    'hostname': 'endpoint1.collection.eu.sumologic.com',
    'path': "/receiver/v1/http/<XXXX>",
    'method': 'POST'
};

function cloudTrailLogsToSumo(bucket, objKey, context, s3) {
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

    var s3Stream = s3.getObject({ Bucket: bucket, Key: objKey }).createReadStream();
    s3Stream.on('error', function(error) {
        context.fail(error);
    });

    var isCompressed = !!objKey.match(/\.gz$/);
    if (isCompressed) {
        s3Stream = s3Stream.pipe(zlib.createGunzip());
    }

    var totalLogs = 0;

    s3Stream
        .on('data', function(data) {
            var logs = JSON.parse(data);
            
            logs.Records.forEach(function(log) {
                req.write(JSON.stringify(log) + '\n');
                totalLogs++;
            });
        })
        .on('end', function() {
            console.log("End of stream");
            console.log("Total logs sent: " + totalLogs);
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
        cloudTrailLogsToSumo(bucket, objKey, context, s3);
    });
};

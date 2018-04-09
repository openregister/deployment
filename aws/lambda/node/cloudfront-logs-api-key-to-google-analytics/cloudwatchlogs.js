const zlib = require('zlib');
const https = require('https');
const querystring = require('querystring');

exports.handler = function (input, context, callback) {
  const payload = Buffer.from(input.awslogs.data, 'base64');
  zlib.gunzip(payload, (e, result) => {
    if (e) {
      callback(e);
    } else {
      result = JSON.parse(result.toString('ascii'));
      const eventCount = result.logEvents.length;
      result.logEvents.forEach(logEvent => {
        const event = logEvent.message.split('\t').slice(-1)[0];
        console.log(event);
        const requestData = JSON.parse(event);
        console.log(requestData);

        const envTid = process.env.TID;
        const envCid = process.env.CID;

        const data = querystring.stringify({
            v: 1,
            t: "pageview",
            tid: envTid,
            cid: envCid,
            aip: 1,
            ni: 1,
            dl: requestData.endpoint,
            cd2: requestData.apikey,
            cd5: requestData.hittype
          });

        const options = {
          host: 'www.google-analytics.com',
          hostname: 'www.google-analytics.com',
          port: 443,
          path: '/collect',
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': data.length
          }
        };

        const request = https.request(options, res => {
          console.log('statusCode:', res.statusCode);

          res.on('error', err => {
            callback(err);
          });
        });

        request.on('error', err => {
          callback(err);
        });

        request.write(data);
        request.end();
      });
      callback(null, `finished sending ${eventCount} event(s)`);
    }
  });
};
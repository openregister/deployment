var fs = require('fs');

module.exports = {
  uncompressed: {
    cloudtrail_logs: fs.readFileSync("test/fixtures/cloudtrail-logs-uncompressed.log"),
    processed_logs: fs.readFileSync("test/fixtures/cloudtrail-logs-expected.log"),
    lambda_event: {
      Records: [{
        s3: {
          bucket: {
            name: "fake-log-bucket"
          },
          object: {
            key: "fake-log-file"
          }
        }
      }]
    }
  },
  compressed: {
    cloudtrail_logs: fs.readFileSync("test/fixtures/cloudtrail-logs-compressed.gz"),
    processed_logs: fs.readFileSync("test/fixtures/cloudtrail-logs-expected.log"),
    lambda_event: {
      Records: [{
        s3: {
          bucket: {
            name: "fake-log-bucket"
          },
          object: {
            key: "fake-log-file.gz"
          }
        }
      }]
    }
  }
};

var subject = require('../cloudtrail'),
  AWS = require('aws-sdk-mock'),
  assert = require('assert'),
  nock = require('nock'),
  TEST_DATA = require('./helpers/test-data');

describe("Sumo Logic S3 CloudTrail Lambda", function() {
  before(function() {
    nock.disableNetConnect();
  });

  describe(".handler", function() {
    afterEach(function() {
      nock.cleanAll();
      AWS.restore("S3");
    });

    it("should send compressed logs to Sumo Logic", function(done) {
      var http_mock = nock('https://endpoint1.collection.eu.sumologic.com')
        .post("/receiver/v1/http/%3CXXXX%3E", TEST_DATA.uncompressed.processed_logs)
        .reply(200);

      AWS.mock("S3", "getObject", TEST_DATA.compressed.cloudtrail_logs);

      subject.handler(TEST_DATA.compressed.lambda_event, {}, function(error) {
        assert.equal(error, undefined);
        http_mock.done();
        done();
      });
    });

    it("should send logs to Sumo Logic", function(done) {
      var http_mock = nock('https://endpoint1.collection.eu.sumologic.com')
        .post("/receiver/v1/http/%3CXXXX%3E", TEST_DATA.uncompressed.processed_logs)
        .reply(200);

      AWS.mock("S3", "getObject", TEST_DATA.uncompressed.cloudtrail_logs);

      subject.handler(TEST_DATA.uncompressed.lambda_event, {}, function(error) {
        assert.equal(error, undefined);
        http_mock.done();
        done();
      });
    });

    it("should error if Sumo Logic returns non-200 response", function(done) {
      var http_mock = nock('https://endpoint1.collection.eu.sumologic.com')
        .post("/receiver/v1/http/%3CXXXX%3E", TEST_DATA.uncompressed.processed_logs)
        .reply(500);

      AWS.mock("S3", "getObject", TEST_DATA.uncompressed.cloudtrail_logs);

      subject.handler(TEST_DATA.uncompressed.lambda_event, {}, function(error) {
        assert.equal(error, 'status code: 500');
        http_mock.done();
        done();
      });
    });
  });
});

import json
import base64
import unittest
import requests_mock
from freezegun import freeze_time
from requests.exceptions import HTTPError

import performance_platform

EXPECTED_PAYLOAD = [{
    "_timestamp": "2017-05-08T10:00:00+00:00",
    "service": "govuk-registers",
    "check": "govuk-registers-beta-register-name-cdn",
    "period": "hour",
    "downtime": 20,
    "uptime": 3580
}, {
    "_timestamp": "2017-05-08T10:00:00+00:00",
    "service": "govuk-registers",
    "check": "govuk-registers-beta-register-name-origin",
    "period": "hour",
    "downtime": 10,
    "uptime": 3590
}]

FAKE_PINGDOM_CHECKS_RESPONSE = {
    "checks": [{
      "id": 1234,
      "name": "beta - register-name (cdn) - records",
      "tags": [
        {
          "name": "beta",
          "type": "u",
          "count": 2
        }, {
          "name": "cdn",
          "type": "u",
          "count": 1
        }
      ]
    }, {
      "id": 5678,
      "name": "beta - register-name (origin) - records",
      "tags": [
        {
          "name": "beta",
          "type": "u",
          "count": 2
        }, {
          "name": "origin",
          "type": "u",
          "count": 1
        }
      ]
    }
  ],
  "counts": {
    "total": 2,
    "limited": 2,
    "filtered": 2
  }
}

FAKE_CDN_PERFORMANCE_RESPONSE = {
  "summary": {
    "status": {
      "totaldown": 20,
      "totalunknown": 0,
      "totalup": 3580
    }
  }
}

FAKE_ORIGIN_PERFORMANCE_RESPONSE = {
  "summary": {
    "status": {
      "totaldown": 10,
      "totalunknown": 0,
      "totalup": 3590
    }
  }
}

PINGDOM_API_ENDPOINT = "https://api.pingdom.com/api/2.0"
PERFORMANCE_PLATFORM_ENDPOINT = "https://www.performance.service.gov.uk/data/govuk-registers/uptime"

class TestPingdomToPerformancePlatformLambda(unittest.TestCase):
    @freeze_time("2017-05-08T11:37:26.326992")
    def test_should_send_availability_metrics_to_performance_platform(self):
        with requests_mock.Mocker() as m:
            stub_checks_endpoint(m, FAKE_PINGDOM_CHECKS_RESPONSE)
            stub_summary_endpoint(m, 1234, 1494237600, 1494241200, FAKE_CDN_PERFORMANCE_RESPONSE)
            stub_summary_endpoint(m, 5678, 1494237600, 1494241200, FAKE_ORIGIN_PERFORMANCE_RESPONSE)

            m.post(PERFORMANCE_PLATFORM_ENDPOINT,
                    request_headers={ 'Authorization': 'Bearer dummy_bearer' },
                    json={ "status": "ok" },
                    additional_matcher=data_equals(json.dumps(EXPECTED_PAYLOAD))
                    )

            self.assertTrue(performance_platform.lambda_handler(None, None))


    @freeze_time("2017-05-08T11:37:26.326992")
    def test_should_throw_if_checks_endpoint_call_fails(self):
        with requests_mock.Mocker() as m:
            stub_checks_endpoint(m, {}, status_code=500)

            with self.assertRaises(HTTPError):
                performance_platform.lambda_handler(None, None)


    @freeze_time("2017-05-08T11:37:26.326992")
    def test_should_throw_if_summary_endpoint_call_fails(self):
        with requests_mock.Mocker() as m:
            stub_checks_endpoint(m, FAKE_PINGDOM_CHECKS_RESPONSE)
            stub_summary_endpoint(m, 1234, 1494237600, 1494241200, {}, status_code=500)

            with self.assertRaises(HTTPError):
                performance_platform.lambda_handler(None, None)


    @freeze_time("2017-05-08T11:37:26.326992")
    def test_should_throw_if_performance_platform_endpoint_call_fails(self):
        with requests_mock.Mocker() as m:
            stub_checks_endpoint(m, FAKE_PINGDOM_CHECKS_RESPONSE)
            stub_summary_endpoint(m, 1234, 1494237600, 1494241200, FAKE_CDN_PERFORMANCE_RESPONSE)
            stub_summary_endpoint(m, 5678, 1494237600, 1494241200, FAKE_ORIGIN_PERFORMANCE_RESPONSE)

            m.post(PERFORMANCE_PLATFORM_ENDPOINT,
                    request_headers={ 'Authorization': 'Bearer dummy_bearer' },
                    status_code=500
                    )

            with self.assertRaises(HTTPError):
                performance_platform.lambda_handler(None, None)


def data_equals(data):
    def _data_equals(request):
        return data == request.text
    return _data_equals


def stub_checks_endpoint(m, body, status_code=200):
    stub_pingdom(m, "/checks?tags=beta", body, status_code)


def stub_summary_endpoint(m, checkid, time_from, time_to, body, status_code=200):
    stub_pingdom(m, "/summary.average/{}?resolution=hour&includeuptime=true&from={}&to={}".format(checkid, time_from, time_to), body, status_code)


def stub_pingdom(m, endpoint, body, status_code):
    m.get("{}{}".format(PINGDOM_API_ENDPOINT, endpoint),
            request_headers = {
                'Authorization': 'Basic {}'.format(base64.b64encode(b'dummy_username:dummy_password').decode('ascii')),
                'App-Key': 'dummy_key'
                },
            json=body,
            status_code=status_code
            )

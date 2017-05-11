import json
import unittest
import requests_mock
from freezegun import freeze_time
from requests.exceptions import HTTPError

import performance_platform

EXPECTED_PAYLOAD = {
    "_timestamp": "2017-05-08T00:00:00+00:00",
    "service": "govuk-registers",
    "check": "govuk-registers",
    "period": "day",
    "uptime": 0.50
}

FAKE_STATUSCAKE_RESPONSE = [
    {
        "TestID": 123,
        "Paused": False,
        "TestType": "HTTP",
        "WebsiteName": "beta - foo - home",
        "ContactGroup": ["54321"],
        "Public": 0,
        "Status": "Up",
        "NormalisedResponse": 0,
        "Uptime": 100
    }, {
        "TestID": 1234,
        "Paused": False,
        "TestType": "HTTP",
        "WebsiteName": "beta - foo - records",
        "ContactGroup": ["54321"],
        "Public": 0,
        "Status": "Up",
        "NormalisedResponse": 0,
        "Uptime": 100
    }, {
        "TestID": 12345,
        "Paused": False,
        "TestType": "HTTP",
        "WebsiteName": "beta - bar - records",
        "ContactGroup": ["54321"],
        "Public": 0,
        "Status": "Up",
        "NormalisedResponse": 0,
        "Uptime": 0
    }
]

STATUSCAKE_ENDPOINT = "https://app.statuscake.com/API/Tests"
PERFORMANCE_PLATFORM_ENDPOINT = "https://www.performance.service.gov.uk/data/govuk-registers/monitoring"

def data_equals(data):
    def _data_equals(request):
        return data == request.text
    return _data_equals

class TestStatusCakeToPerformancePlatformLambda(unittest.TestCase):
    @freeze_time("2017-05-08T11:37:26.326992")
    def test_should_send_mean_uptimes_to_performance_platform(self):
        with requests_mock.Mocker() as m:
            m.get(STATUSCAKE_ENDPOINT,
                  request_headers = { 'API': 'dummy_key', 'Username': 'dummy_username' },
                  json=FAKE_STATUSCAKE_RESPONSE
            )

            m.post(PERFORMANCE_PLATFORM_ENDPOINT,
                   request_headers={ 'Authorization': 'Bearer dummy_bearer' },
                   json={ "status": "ok" },
                   additional_matcher=data_equals(json.dumps(EXPECTED_PAYLOAD))
            )

            self.assertTrue(performance_platform.lambda_handler(None, None))

    def test_should_throw_if_statuscake_returns_non_200(self):
        with requests_mock.Mocker() as m:
            m.get(STATUSCAKE_ENDPOINT, status_code=500)
            with self.assertRaises(HTTPError):
                res = performance_platform.lambda_handler(None, None)

    def test_should_throw_if_performance_plaform_returns_non_200(self):
        with requests_mock.Mocker() as m:
            m.get(STATUSCAKE_ENDPOINT,
                  request_headers = { 'API': 'dummy_key', 'Username': 'dummy_username' },
                  json=FAKE_STATUSCAKE_RESPONSE
            )

            m.post(PERFORMANCE_PLATFORM_ENDPOINT,
                   status_code=500
            )

            with self.assertRaises(HTTPError):
                res = performance_platform.lambda_handler(None, None)

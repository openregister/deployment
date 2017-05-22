import requests
import json
import re
from statistics import mean
from datetime import datetime

STATUSCAKE_API_KEY = "dummy_key"
STATUSCAKE_API_USERNAME = "dummy_username"
STATUSCAKE_ENDPOINT = "https://app.statuscake.com/API/Tests"

PERFORMANCE_PLATFORM_BEARER_TOKEN=  "dummy_bearer"
PERFORMANCE_PLATFORM_ENDPOINT = "https://www.performance.service.gov.uk/data/govuk-registers/uptime"

WEBSITE_MATCHER = re.compile("^beta.*records$")

def lambda_handler(event, context):
    print("Requesting uptimes from Statuscake...")
    tests_response = requests.get(STATUSCAKE_ENDPOINT, headers={
        "API": STATUSCAKE_API_KEY,
        "Username": STATUSCAKE_API_USERNAME
    })
    tests_response.raise_for_status()
    results = tests_response.json()

    print("StatusCake response: {}".format(results))
    uptimes = [result['Uptime'] for result in results if WEBSITE_MATCHER.match(result['WebsiteName'])]
    print("Uptimes: {}".format(uptimes))
    mean_uptime = mean(uptimes)/100.0
    print("Mean uptime: {}".format(mean_uptime))

    performance_platform_payload =  {
        "_timestamp": datetime.utcnow().strftime("%Y-%m-%dT00:00:00+00:00"),
        "service": "govuk-registers",
        "check": "govuk-registers",
        "period": "day",
        "uptime": mean_uptime
    }

    print("Payload: {}".format(performance_platform_payload))
    print("Sending mean uptime to Performance Platform...")
    performance_platform_response = requests.post(
        PERFORMANCE_PLATFORM_ENDPOINT,
        headers={ 'Authorization': 'Bearer {}'.format(PERFORMANCE_PLATFORM_BEARER_TOKEN) },
        json=performance_platform_payload
    )

    print("Performance platform response: {}".format(performance_platform_response.text))
    performance_platform_response.raise_for_status()
    return performance_platform_response.json()["status"] == "ok"

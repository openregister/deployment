#!/usr/bin/env python3

import requests
import logging
import json
import re
import sys
from datetime import datetime, timedelta
import calendar

configuration = {
    "tagged-checks": "beta",
    "pingdom": {
        "key": "dummy_key",
        "username": "dummy_username",
        "password": "dummy_password"
    },
    "performance-platform": {
        "token": "dummy_bearer"
    }
}

logging.basicConfig(stream=sys.stderr)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

class Pingdom(object):
    API_BASE = "https://api.pingdom.com/api/2.0"

    def __init__(self, configuration):
        self.configuration = configuration

    def get(self, endpoint):
        logger.info("Pingdom Request: {}".format(endpoint))
        response = requests.get("{}{}".format(self.API_BASE, endpoint),
                auth=(self.configuration["username"], self.configuration["password"]),
                headers={ "App-Key": self.configuration["key"]},
                )
        response.raise_for_status()

        logger.info("Pingdom Response: {}".format(response.json()))
        return response.json()


class PerformancePlatform(object):
    API_BASE = "https://www.performance.service.gov.uk"

    def __init__(self, configuration):
        self.configuration = configuration

    def post(self, endpoint, body):
        logger.info("Performance Platform Request: {}".format(endpoint))
        response = requests.post(
                "{}{}".format(self.API_BASE, endpoint),
                headers={'Authorization': 'Bearer {}'.format(self.configuration["token"])},
                json=body
                )
        response.raise_for_status()

        logger.info("Performance Platform Response: {}".format(response.json()))
        return response.json()


def lambda_handler(event, context, configuration=configuration):
    performance_platform = PerformancePlatform(configuration["performance-platform"])
    pingdom = Pingdom(configuration["pingdom"])

    performance_platform_payload = build_payload(pingdom, configuration["tagged-checks"])

    performance_platform_response = performance_platform.post(
        "/data/govuk-registers/uptime",
        performance_platform_payload
    )
    return performance_platform_response["status"] == "ok"


def build_payload(pingdom, tag):
    def to_unix_timestamp(date):
        return calendar.timegm(date.utctimetuple())

    checks = pingdom.get("/checks?tags={}".format(tag))["checks"]

    start_of_previous_hour = datetime.utcnow().replace(minute=0, second=0, microsecond=0) - timedelta(hours=1)

    payload = []
    details_matcher = re.compile('^(.*?) - (.*?) \((.*)\).*$')
    for check in checks:
        phase, register, location = details_matcher.match(check["name"]).groups()

        summary = pingdom.get(
                "/summary.average/{}?resolution=hour&includeuptime=true&from={}&to={}".format(
                    check["id"],
                    to_unix_timestamp(start_of_previous_hour),
                    to_unix_timestamp(start_of_previous_hour + timedelta(hours=1))
                    )
                )

        timestamp = start_of_previous_hour.strftime("%Y-%m-%dT%H:00:00+00:00")
        uptime = summary["summary"]["status"]["totalup"]
        downtime = summary["summary"]["status"]["totaldown"]
        payload.append({
            "_timestamp": timestamp,
            "service": "govuk-registers",
            "check": "govuk-registers-{}-{}-{}".format(phase, register, location),
            "period": "hour",
            "downtime": downtime,
            "uptime": uptime
            })

        print("{}\t{}\t{}\t{}\t{}\t{}".format(timestamp, phase, register, location, downtime, uptime))

    return payload


if __name__ == "__main__":
    import os

    pingdom = Pingdom({
        "username": os.environ["PINGDOM_USERNAME"],
        "password": os.environ["PINGDOM_PASSWORD"],
        "key": os.environ["PINGDOM_KEY"]
        })

    build_payload(pingdom, "beta")

# Forward availability from Pingdom to Performance Platform

## Running Tests

```bash
$ python3 -m unittest
```

## Running Locally

You can run it locally to generate some output (does not publish to Performance Platform):

```bash
PINGDOM_KEY=$(registers-pass show services/pingdom/api | head -n1) PINGDOM_USERNAME=$(registers-pass show services/pingdom | tail -n 1) PINGDOM_PASSWORD=$(registers-pass show services/pingdom| head -n1) ./performance_platform.py 2>/dev/null
```

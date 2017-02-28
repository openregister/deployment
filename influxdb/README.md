# InfluxDB Configuration

## Prerequisites

You will need the `influx` CLI tool. You can get it from Homebrew:

```
brew install influxdb
```

You will need `jinja2-cli`, you can install that with pip:

```
pip install -r requirements.txt
```

## Deploying

You can see what will be executed before applying changes with:

```
make -n apply
```

You can then apply those changes with:

```
make apply
```

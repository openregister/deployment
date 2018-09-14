# Node Lambdas

## Running Locally

### Setup
Install [aws-sam-cli](https://github.com/awslabs/aws-sam-cli) in a virtual environment:

```
python3 -m venv .venv/
source .venv/bin/activate
pip install -r requirements.txt
```

### Running lambdas
From `deployment/aws/lambda/node` directory:

```
sam local invoke "CloudfrontPostLoggerFunction" --event ./cloudfront-post-logger/example_request.json 
```

```
sam local invoke "CacheInvalidatorFunction" --event ./cache-invalidator/example_event.json 
```

Lambdas to run locally are defined in `template.yml`



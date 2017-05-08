# CloudFront to Sumo Logic Lambda function

This is based off [Sumologic/sumologic-aws-lambda](https://github.com/SumoLogic/sumologic-aws-lambda). In addition to shipping logs to Sumo Logic it also "anonymizes" data by removing octets from the client's IP address.

## Testing

There are some (not very good) unit tests. You can invoke them with:

```
npm install
npm test
```

You can manually invoke the lambda task and check the logs end up in Sumo Logic. You will need to tweak the bucket and object location in `test/example/event.json` as well as making sure the correct Sumo Logic endpoint is used in `s3.js`. You can then execute this:

```
lambda-local -l s3.js -h handler -e test/example/event.json -t 20
```

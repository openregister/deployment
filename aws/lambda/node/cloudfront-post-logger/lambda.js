'use strict'

exports.handler = (event, context, callback) => {
  // Console.log(JSON.stringify(event))

  const {request} = event.Records[0].cf
  if (request.method === 'POST') {
    // TODO: Include Body option is not currently supported by Terraform
    // const body = request.body.data;
    // const decodedBody = Buffer.from(body, 'base64').toString('ascii');
    const host = request.headers.host[0].value
    const {distributionId} = event.Records[0].cf.config
    const message = {
      distributionId,
      // TODO: Include Body option is not currently supported by Terraform
      // body: decodedBody,
      eventType: 'loadRSF',
      host
    }
    const json = JSON.stringify(message)
    console.log(json)
  }
  callback(null, request)
}

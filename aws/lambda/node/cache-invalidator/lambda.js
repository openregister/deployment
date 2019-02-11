const zlib = require('zlib')
const AWS = require('aws-sdk') // eslint-disable-line import/no-unresolved

const cloudfront = new AWS.CloudFront()

exports.handler = async event => {
  // Log event
  // console.log(JSON.stringify(event))
  const payload = Buffer.from(event.awslogs.data, 'base64')
  const parsed = JSON.parse(zlib.gunzipSync(payload).toString('utf8'))
  console.log('Decoded payload:', JSON.stringify(parsed))

  const logEvent = parsed.logEvents[0]
  const {message} = logEvent
  const messageParts = message.split('\t')
  const messageObject = messageParts[2]
  const parsedMessageObject = JSON.parse(messageObject)
  console.log(parsedMessageObject)
  const {distributionId} = parsedMessageObject
  const callerReference = 'cache-invalidator-lambda-' + new Date().toISOString()
  const {host} = parsedMessageObject

  const getDistributionId = async () => {
    const isBeta = host.split('.')[1] === 'beta'

    if (isBeta) {
      let distributions
      try {
        distributions = await cloudfront.listDistributions({MaxItems: '1000'}).promise()
      } catch (error) {
        throw new Error(`List Distributions failed: ${error}`)
      }
      const registerGovUkDomain = host.replace('beta.openregister.org', 'register.gov.uk')
      const registerGovUkDistribution = distributions.Items.find(item => item.Aliases.Items.includes(registerGovUkDomain))
      if (registerGovUkDistribution && registerGovUkDistribution.Id) {
        return (registerGovUkDistribution.Id)
      }
      throw new Error('matching distribution not found')
    } else {
      return distributionId
    }
  }

  const distributionIdToInvalidate = await getDistributionId()

  const params = {
    DistributionId: distributionIdToInvalidate, /* Required */
    InvalidationBatch: { /* Required */
      CallerReference: callerReference, /* Required */
      Paths: { /* Required */
        Quantity: 9, /* Required */
        Items: [
          '/download-register',
          '/',
          '/records',
          '/records*',
          '/register*',
          '/entries',
          '/entries*',
          '/download-rsf*',
          '/proof/register/merkle:sha-256'
        ]
      }
    }
  }

  console.log('Params:', JSON.stringify(params))

  return cloudfront.createInvalidation(params).promise()
}

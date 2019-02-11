'use strict'

const dataFormatRegex = /(csv|tsv|json|yaml|ttl|download-rsf)(\/{0,1}\?{0,1}.*)?$/

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request

  // Let request continue immediately then carry out our logic
  callback(null, request)

  if (request.uri.includes('assets')) {
    console.log('Assets request - returning')
    return
  }

  if (request.uri.match(dataFormatRegex) === null) {
    console.log('Regex not matched')

    const contentType = request.headers.accept ? request.headers.accept[0].value.match(dataFormatRegex) : null

    if (contentType === null) {
      console.log('Accept not matched.')
      console.log(request)
      return
    }

    request.uri = request.uri + '.' + contentType[0]
  }

  const apikey = request.headers.authorization ? request.headers.authorization[0].value : 'Anonymous'
  const host = request.headers.host[0].value
  const useragent = request.headers['user-agent'] && request.headers['user-agent'][0].value
  const hittype = useragent === 'CL' ? 'Client Library' : 'API'
  const queryParams = (request.querystring === '') ? '' : '?' + request.querystring
  const endpoint = 'https://' + host + request.uri + queryParams

  const data = {
    apikey,
    endpoint,
    hittype,
    useragent
  }

  // This comment is to write to CloudWatch logs for events to be sent to GA.
  console.log(JSON.stringify(data))
}

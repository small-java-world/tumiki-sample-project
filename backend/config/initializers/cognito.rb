require 'aws-sdk-cognitoidentityprovider'

CognitoClient = Aws::CognitoIdentityProvider::Client.new(
  region: ENV.fetch('AWS_REGION'),
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  endpoint: 'http://cognito:5000'
)

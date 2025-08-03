pool = CognitoClient.create_user_pool(pool_name: ENV.fetch("COGNITO_USER_POOL_ID", "local_pool"))
puts "Created user pool #{pool.user_pool.id}"

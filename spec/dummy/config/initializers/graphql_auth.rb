GraphQL::Auth.configure do |config|
  # config.token_lifespan = 4.hours
  # config.jwt_secret_key = ENV['JWT_SECRET_KEY']
  # config.app_url = ENV['APP_URL']

  # config.user_type = '::Types::Auth::User'

  config.sign_up_mutation = true
  config.lock_account_mutation = true
  config.unlock_account_mutation = true
end
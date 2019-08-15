# Changelog

## 0.6.0

### New features

Added to possibility to use your own sign_up and update_account mutations
to allow custom fields for your user accounts

### Breaking changes

Configuration file was changed and some config names now have a different
use.

Please make sure to update your config file with the current version.

**Those settings were renamed for more clarity**
* sign_up_mutation => allow_sign_up
* lock_account_mutation => allow_lock_account
* unlock_account_mutation => allow_unlock_account

The updated config file should look like this:
```
GraphQL::Auth.configure do |config|
  # config.token_lifespan = 4.hours
  # config.jwt_secret_key = ENV['JWT_SECRET_KEY']
  # config.app_url = ENV['APP_URL']

  # config.user_type = '::Types::Auth::User'

  # Devise allowed actions
  # Don't forget to enable the lockable setting in your Devise user model if you plan on using the lock_account feature
  # config.allow_sign_up = true
  # config.allow_lock_account = false
  # config.allow_unlock_account = false

  # Allow custom mutations for signup and update account
  # config.sign_up_mutation = '::Mutations::Auth::SignUp'
  # config.update_account_mutation = '::Mutations::Auth::UpdateAccount'
end
```

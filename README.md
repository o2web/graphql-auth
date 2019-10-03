# GraphQL Auth

[![Build Status](https://travis-ci.org/o2web/graphql-auth.svg?branch=master)](https://travis-ci.org/o2web/graphql-auth) [![Maintainability](https://api.codeclimate.com/v1/badges/7e2515bb59f0b205a603/maintainability)](https://codeclimate.com/github/o2web/graphql-auth/maintainability)
[![Downloads](https://img.shields.io/gem/dt/graphql-auth.svg)](https://rubygems.org/gems/graphql-auth)
[![Latest Version](https://img.shields.io/gem/v/graphql-auth.svg)](https://rubygems.org/gems/graphql-auth)

This gem provides an authentication mechanism on a GraphQL API. It use JSON Web Token (JWT) and Devise logic.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-auth

Then run the installer to create `graphql_auth.rb` file in your initializers folder.

```
rails g graphql_auth:install
```

Make sure to read all configurations present inside the file and fill them with your own configs.

## Devise gem

 Use Devise with a User model and skip all route

 ```ruby
Rails.application.routes.draw do
  devise_for :users, skip: :all
end
```

## Usage

Make 'JWT_SECRET_KEY' and 'APP_URL' available to ENV

```
JWT_SECRET_KEY=
APP_URL=
```

Make sure the `Authorization` header is allowed in your api

```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*',
             headers: %w(Authorization Expires RefreshToken),
             methods: :any,
             expose: %w(Authorization Expires RefreshToken),
             max_age: 600
  end
end
```

Make sure to include `Graphql::AuthHelper` in your `GraphqlController`. A context method returning the current_user will be available

```ruby
class GraphqlController < ActionController::API

  include Graphql::AuthHelper

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    result = ::GraphqlSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result

    ...
```

Make sure to implement `GraphqlAuth` in your `MutationType` to make auth mutations available

```ruby
class Types::MutationType < Types::BaseObject
  implements ::Types::GraphqlAuth
end
```

## Customization

If you can to customize any mutation, make sure to update the configurations

```ruby
GraphQL::Auth.configure do |config|
  # config.token_lifespan = 4.hours
  # config.jwt_secret_key = ENV['JWT_SECRET_KEY']
  # config.app_url = ENV['APP_URL']

  # config.user_type = '::Types::Auth::User'
  # config.sign_up_input_type = '::Types::Auth::Inputs::SignUp'
  # config.update_account_input_type = '::Types::Auth::Inputs::UpdateAccount' 
  # config.update_password_input_type = '::Types::Auth::Inputs::UpdatePassword'

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `graphql-auth.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/o2web/graphql-auth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GraphQL Auth project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/o2web/graphql-auth/blob/master/CODE_OF_CONDUCT.md).

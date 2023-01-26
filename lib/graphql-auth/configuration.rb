module GraphQL
  module Auth
    class Configuration
      attr_accessor :token_lifespan,
                    :jwt_secret_key,
                    :app_url,
                    :user_type,
                    :allow_sign_up,
                    :allow_lock_account,
                    :allow_unlock_account,
                    :allow_email_confirmable,
                    :sign_up_mutation,
                    :update_account_mutation

      def initialize
        @token_lifespan = 4.hours
        @jwt_secret_key = ENV['JWT_SECRET_KEY']
        @app_url = ENV['APP_URL']

        @user_type = '::Types::Auth::User'

        # Devise allowed actions
        @allow_sign_up = true
        @allow_lock_account = false
        @allow_unlock_account = false
        @allow_email_confirmable = false

        # Allow custom mutations for signup and update account
        @sign_up_mutation = '::Mutations::Auth::SignUp'
        @update_account_mutation = '::Mutations::Auth::UpdateAccount'
      end
    end
  end
end

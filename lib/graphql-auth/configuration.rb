module GraphQL
  module Auth
    class Configuration
      attr_accessor :token_lifespan,
                    :jwt_secret_key,
                    :app_url,
                    :user_type,
                    :sign_up_input_type,
                    :update_account_input_type,
                    :update_password_input_type,
                    :sign_up_mutation,
                    :lock_account_mutation,
                    :unlock_account_mutation

      def initialize
        @token_lifespan = 4.hours
        @jwt_secret_key = ENV['JWT_SECRET_KEY']
        @app_url = ENV['APP_URL']

        @user_type = '::Types::Auth::User'
        @sign_up_input_type = '::Types::Auth::Inputs::SignUp'
        @update_account_input_type = '::Types::Auth::Inputs::UpdateAccount'
        @update_password_input_type = '::Types::Auth::Inputs::UpdatePassword'

        @sign_up_mutation = false
        @lock_account_mutation = false
        @unlock_account_mutation = false
      end
    end
  end
end

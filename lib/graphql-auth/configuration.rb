module GraphQL
  module Auth
    class Configuration
      attr_accessor :token_lifespan,
                    :jwt_secret_key,
                    :app_url,
                    :user_type,
                    :sign_in_mutation,
                    :sign_up_mutation,
                    :forgot_password_mutation,
                    :reset_password_mutation,
                    :update_account_mutation,
                    :validate_token_mutation

      def initialize
        @token_lifespan = 4.hours
        @jwt_secret_key = ENV['JWT_SECRET_KEY']
        @app_url = ENV['APP_URL']

        @user_type = ::Types::Auth::User

        @sign_in_mutation = ::Mutations::Auth::SignIn
        @sign_up_mutation = ::Mutations::Auth::SignUp

        @forgot_password_mutation = ::Mutations::Auth::ForgotPassword
        @reset_password_mutation = ::Mutations::Auth::ResetPassword

        @update_account_mutation = ::Mutations::Auth::UpdateAccount

        @validate_token_mutation = ::Mutations::Auth::ValidateToken
      end
    end
  end
end

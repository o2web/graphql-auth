module GraphQL
  module Auth
    class Configuration
      attr_accessor :token_lifespan,
                    :jwt_secret_key,
                    :app_url,
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
        
        @sign_in_mutation = ::Mutations::SignIn
        @sign_up_mutation = ::Mutations::SignUp
      
        @forgot_password_mutation = ::Mutations::ForgotPassword
        @reset_password_mutation = ::Mutations::ResetPassword
      
        @update_account_mutation = ::Mutations::UpdateAccount
      
        @validate_token_mutation = ::Mutations::ValidateToken
      end
    end
  end
end

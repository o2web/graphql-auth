# frozen_string_literal: true

# mutation {
#   signIn(email: "email@example.com", password: "password") {
#     user {
#       email
#     }
#     errors {
#       field
#       message
#     }
#   }
# }

class Mutations::Auth::SignIn < GraphQL::Schema::Mutation
  argument :email, String, required: true do
    description "The user's email"
  end

  argument :password, String, required: true do
    description "The user's password"
  end

  # field :user, Types::Auth::User, null: true
  field :errors, [Types::Auth::Error], null: true
  
  def resolve(email:, password:)
    response = context[:response]
    user = User.find_by email: email
    valid_sign_in = user.present? && user.valid_password?(password)
    
    if valid_sign_in
      response.set_header 'Authorization', GraphQL::Auth::JwtManager.issue({ user: user.id }) # TODO use uuid
      {
        user: user
      }
    else
      {
        errors: [
          {
            field: :_error,
            message: I18n.t('devise.failure.invalid',
                            authentication_keys: I18n.t('activerecord.attributes.user.email'))
          }
        ]
      }
    end
  end
end

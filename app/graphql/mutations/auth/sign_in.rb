# frozen_string_literal: true

# mutation {
#   signIn(email: "email@example.com", password: "password") {
#     success
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
  include ::Graphql::TokenHelper

  argument :email, String, required: true do
    description "The user's email"
  end

  argument :password, String, required: true do
    description "The user's password"
  end

  argument :remember_me, Boolean, required: true do
    description "User's checkbox to be remembered after connection timeout"
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, ::Types::Auth::User, null: true

  def resolve(email:, password:, remember_me:)
    response = context[:response]

    user = User.find_by email: email
    valid_sign_in = user.present? && user.valid_password?(password)

    if valid_sign_in
      generate_access_token(user, response)
      remember_me ? set_refresh_token(user, response) : delete_refresh_token(user)

      puts remember_me

      {
        errors: [],
        success: true,
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
        ],
        success: false,
        user: nil,
      }
    end
  end
end

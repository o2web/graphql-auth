# frozen_string_literal: true

class Mutations::Auth::SignIn < GraphQL::Schema::Mutation
  include ::Graphql::AccountLockHelper
  include ::Graphql::TokenHelper

  argument :email, String, required: true do
    description "The user's email"
  end

  argument :password, String, required: true do
    description "The user's password"
  end

  argument :remember_me, Boolean, required: false do
    description "User's checkbox to be remembered after connection timeout"
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

  def resolve(email:, password:, remember_me:)
    response = context[:response]

    if lockable?
      user = User.where(locked_at: nil).find_by email: email
    else
      user = User.find_by email: email
    end

    valid_sign_in = user.present? && user.valid_password?(password)

    # check confirmable
    if valid_sign_in && user.respond_to?(:confirmed?) && !user.active_for_authentication?
      return {
        errors: [
          {
            field: :_error,
            message: I18n.t('devise.failure.unconfirmed')
          }
        ],
        success: false,
        user: nil
      }
    end

    if valid_sign_in
      generate_access_token(user, response)
      set_current_user(user)
      remember_me ? set_refresh_token(user, response) : delete_refresh_token(user)

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
        user: nil
      }
    end
  end
end

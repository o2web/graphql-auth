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

    user = User.find_by email: email
    valid_sign_in = user.present? && user.valid_password?(password)

    device_lockable_enabled = user.lock_strategy_enabled?(:failed_attempts)

    if device_lockable_enabled
      if user.access_locked?
        return {
          errors: [
            {
              field: :_error,
              message: I18n.t('devise.failure.locked')
            }
          ],
          success: false,
          user: nil
        }
      end

      user.increment_failed_attempts

      if user.send('attempts_exceeded?')
          user.lock_access! unless user.access_locked?

          return {
            errors: [
              {
                field: :_error,
                message: I18n.t('devise.failure.locked')
              }
            ],
            success: false,
            user: nil
          }
      else
        user.save(validate: false) 
      end
    end

    # TODO return locked message, when account locked


    if valid_sign_in
      generate_access_token(user, response)
      set_current_user(user)
      remember_me ? set_refresh_token(user, response) : delete_refresh_token(user)
    else
      return {
        errors: [
          {
            field: :_error,
            message: I18n.t('devise.failure.noaccess')
          }
        ],
        success: false,
        user: nil
      }
    end
  end
end
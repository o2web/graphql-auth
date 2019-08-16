# frozen_string_literal: true

class Mutations::Auth::ResetPassword < GraphQL::Schema::Mutation
  include ::Graphql::AccountLockHelper

  argument :reset_password_token, String, required: true do
    description "Reset password token"
  end

  argument :password, String, required: true do
    description "New user's new password"
  end

  argument :password_confirmation, String, required: true do
    description "New user's new password confirmation"
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false

  def resolve(args)
    if lockable?
      user = User.where(locked_at: nil).reset_password_by_token args
    else
      user = User.reset_password_by_token args
    end

    if user.errors.any?
      {
        success: false,
        errors: user.errors.messages.map { |field, messages|
          error_field = field == :reset_password_token ? :_error : field.to_s.camelize(:lower)

          {
            field: error_field,
            message: messages.first.capitalize,
            details: user.errors.details.dig(field)
          }
        }
      }
    else
      {
        errors: [],
        success: true
      }
    end
  end
end

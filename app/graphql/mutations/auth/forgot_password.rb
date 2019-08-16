# frozen_string_literal: true

class Mutations::Auth::ForgotPassword < GraphQL::Schema::Mutation
  include ::Graphql::AccountLockHelper

  argument :email, String, required: true do
    description 'The email with forgotten password'
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :valid, Boolean, null: false

  def resolve(email:)
    if lockable?
      user = User.where(locked_at: nil).find_by email: email
    else
      user = User.find_by email: email
    end

    user.send_reset_password_instructions if user.present?

    {
      errors: [],
      success: true,
      valid: true
    }
  end
end

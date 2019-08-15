# frozen_string_literal: true

class Mutations::Auth::ValidateToken < GraphQL::Schema::Mutation
  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, GraphQL::Auth.configuration.user_type.constantize, null: true
  field :valid, Boolean, null: false

  def resolve
    user = context[:current_user]

    if user.present? && !account_locked(user)
      {
        errors: [],
        success: true,
        user: user,
        valid: true
      }
    else
      {
        errors: [],
        success: false,
        user: nil,
        valid: false
      }
    end
  end

  def account_locked(user)
    GraphQL::Auth.configuration.allow_lock_account && user.access_locked?
  end
end
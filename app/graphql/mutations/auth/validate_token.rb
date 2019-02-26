# frozen_string_literal: true

class Mutations::Auth::ValidateToken < GraphQL::Schema::Mutation
  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, ::Types::Auth::User, null: true
  field :valid, Boolean, null: false

  def resolve
    user = context[:current_user]

    if user.present? && !user.access_locked?
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
end
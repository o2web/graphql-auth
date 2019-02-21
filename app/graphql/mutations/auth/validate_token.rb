# frozen_string_literal: true

class Mutations::Auth::ValidateToken < GraphQL::Schema::Mutation
  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, ::Types::Auth::User, null: true
  field :valid, Boolean, null: false

  def resolve
    user = context[:current_user]

    {
      errors: [],
      success: user.present?,
      user: user,
      valid: user.present?,
    }
  end
end
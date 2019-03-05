# frozen_string_literal: true

class Mutations::Auth::UnlockAccount < GraphQL::Schema::Mutation
  argument :id, ID, required: true do
    description 'User id'
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

  def resolve(id:)
    user = User.where.not(locked_at: nil).find_by id: id

    if context[:current_user] && user.present? && user.unlock_access!
      {
        errors: [],
        success: true,
        user: user
      }
    else
      {
        errors: [
          { field: :_error, message: I18n.t('devise.unlocks.cannot_unlock') }
        ],
        success: false,
        user: user
      }
    end
  end
end
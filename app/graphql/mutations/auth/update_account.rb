# frozen_string_literal: true

class Mutations::Auth::UpdateAccount < GraphQL::Schema::Mutation
  argument :input, GraphQL::Auth.configuration.update_account_input_type.constantize, required: true do
    description "Update account input"
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

  def resolve(input:)
    user = context[:current_user]

    if user.blank?
      return {
        errors: [
          { field: :_error, message: I18n.t('devise.failure.unauthenticated') }
        ],
        success: false,
        user: nil
      }
    end

    user.update_without_password input.to_h

    if user.errors.any?
      {
        errors: user.errors.messages.map do |field, messages|
          { field: field.to_s.camelize(:lower), message: messages.first.capitalize }
        end,
        success: false,
        user: nil
      }
    else
      {
        errors: [],
        success: true,
        user: user
      }
    end
  end
end

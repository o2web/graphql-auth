# frozen_string_literal: true

class Mutations::Auth::SignUp < GraphQL::Schema::Mutation
  include ::Graphql::TokenHelper

  argument :input, GraphQL::Auth.configuration.sign_up_input_type.constantize, required: true do
    description "Sign up input"
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

  def resolve(input:)
    response = context[:response]
    user = User.new input.to_h

    if user.save
      generate_access_token(user, response)

      {
        errors: [],
        success: true,
        user: user
      }
    else
      {
        errors: user.errors.messages.map do |field, messages|
          { field: field.to_s.camelize(:lower), message: messages.first.capitalize }
        end,
        success: false,
        user: nil
      }
    end
  end
end

# frozen_string_literal: true

# mutation {
#  forgotPassword(email: "email@example.com") {
#     valid
#     success
#   }
# }

class Mutations::Auth::ForgotPassword < GraphQL::Schema::Mutation
  argument :email, String, required: true do
    description 'The email with forgotten password'
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false

  def resolve(email:)
    user = User.find_by email: email
    user.send_reset_password_instructions if user.present?

    {
      errors: [],
      success: true,
      valid: true
    }
  end
end

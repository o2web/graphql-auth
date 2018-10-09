# frozen_string_literal: true

# mutation {
#  forgotPassword(email: "email@example.com") {
#     valid
#   }
# }

class Mutations::ForgotPassword < GraphQL::Schema::Mutation
  argument :email, String, required: true do
    description 'The email with forgotten password'
  end

  field :valid, Boolean, null: false
  
  def resolve(email:)
    user = User.find_by email: email
    user.send_reset_password_instructions if user.present?

    { valid: true }
  end
end

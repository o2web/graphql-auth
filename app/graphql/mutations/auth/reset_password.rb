# frozen_string_literal: true

# mutation {
#   resetPassword(resetPasswordToken: "token", password: "password", passwordConfirmation: "password") {
#     valid
#     errors {
#       field
#       message
#     }
#   }
# }

class Mutations::Auth::ResetPassword < GraphQL::Schema::Mutation
  argument :reset_password_token, String, required: true do
    description "Reset password token"
  end

  argument :password, String, required: true do
    description "New user's new password"
  end
  
  argument :password_confirmation, String, required: true do
    description "New user's new password confirmation"
  end

  field :valid, Boolean, null: false
  field :errors, [Types::Auth::Error], null: true
  
  def resolve(args)
    user = User.reset_password_by_token args
    
    if user.errors.any?
      {
        valid: false,
        errors: user.errors.messages.map do |field, messages|
          field = field == :reset_password_token ? :_error : field.to_s.camelize(:lower)
          {
            field: field,
            message: messages.first.capitalize }
        end
      }
    else
      { valid: true }
    end
  end
end

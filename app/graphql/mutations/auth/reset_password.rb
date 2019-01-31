# frozen_string_literal: true

# mutation {
#   resetPassword(resetPasswordToken: "token", password: "password", passwordConfirmation: "password") {
#     success
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

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false

  def resolve(args)
    user = User.reset_password_by_token args

    if user.errors.any?
      {
        success: false,
        errors: user.errors.messages.map do |field, messages|
          field = field == :reset_password_token ? :_error : field.to_s.camelize(:lower)
          {
            field: field,
            message: messages.first.capitalize }
        end
      }
    else
      {
        errors: [],
        success: true
      }
    end
  end
end

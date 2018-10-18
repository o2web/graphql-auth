# frozen_string_literal: true

# mutation {
#   updateAccount(current_password: "currentPassword", password: "newPassword", password_confirmation: "newPassword") {
#     user {
#       email
#     }
#     errors {
#       field
#       message
#     }
#   }
# }

class Mutations::Auth::UpdateAccount < GraphQL::Schema::Mutation
  argument :current_password, String, required: true do
    description "User's current password"
  end
  
  argument :password, String, required: true do
    description "User's new password"
  end
  
  argument :password_confirmation, String, required: true do
    description "User's new password confirmation"
  end
  
  field :user, Types::Auth::User, null: true
  field :errors, [Types::Auth::Error], null: true
  
  def resolve(args)
    user = context[:current_user]
    user.update_with_password args
    
    if user.errors.any?
      {
        errors: user.errors.messages.map do |field, messages|
          { field: field.to_s.camelize(:lower), message: messages.first.capitalize }
        end
      }
    else
      { user: user }
    end
  end
end

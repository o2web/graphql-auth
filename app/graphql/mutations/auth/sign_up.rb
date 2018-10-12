# frozen_string_literal: true

# mutation {
#   signUp(email: "email@example.com", password: "password", passwordConfirmation: "password") {
#     user {
#       email
#     }
#     errors {
#       field
#       message
#     }
#   }
# }

class Mutations::Auth::SignUp < GraphQL::Schema::Mutation
  argument :email, String, required: true do
    description "New user's email"
  end

  argument :password, String, required: true do
    description "New user's password"
  end

  argument :password_confirmation, String, required: true do
    description "New user's password confirmation"
  end

  field :user, Types::Auth::User, null: true
  field :errors, [Types::Auth::Error], null: true
  
  def resolve(args)
    response = context[:response]
    user = User.new args
    
    if user.save
      response.set_header 'Authorization', GraphQL::Auth::JwtManager.issue({ user: user.id }) # TODO use uuid
      { user: user }
    else
      {
        errors: user.errors.messages.map do |field, messages|
          { field: field.to_s.camelize(:lower), message: messages.first.capitalize }
        end
      }
    end
  end
end

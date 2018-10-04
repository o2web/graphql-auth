# frozen_string_literal: true

# mutation {
#   signUp(email: "email@example.com", password: "password", passwordConfirmation: "password") {
#     user {
#       email
#     }
#   }
# }

class Mutations::SignUp < GraphQL::Schema::Mutation
  argument :email, String, required: true do
    description "New user's email"
  end

  argument :password, String, required: true do
    description "New user's password"
  end

  argument :password_confirmation, String, required: true do
    description "New user's password confirmation"
  end

  field :user, Types::User, null: false
  
  def resolve(args)
    response = context[:response]
    user = User.new args
    
    if user.save
      response.set_header 'Authorization', GraphQL::Auth::JwtManager.issue({ user: user.id }) # TODO use uuid
      { user: user }
    else
      message = user.errors.full_messages.first
      context.add_error(GraphQL::ExecutionError.new(message))
    end
  end
end

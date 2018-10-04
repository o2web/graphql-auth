# frozen_string_literal: true

class Mutations::SignIn < GraphQL::Schema::Mutation
  argument :email, String, required: true do
    description "The user's email"
  end

  argument :password, String, required: true do
    description "The user's password"
  end

  field :user, Types::User, null: false
  
  def resolve(email:, password:)
    response = context[:response]
    user = User.find_by email: email
    
    if user.present? && user.valid_password?(password)
      response.set_header 'Authorization', GraphQL::Auth::JwtManager.issue({ user: user.id }) # TODO use uuid
      { user: user }
    else
      message = 'Invalid username or password.'
      context.add_error(GraphQL::ExecutionError.new(message))
    end
  end
end

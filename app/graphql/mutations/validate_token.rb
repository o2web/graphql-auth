# frozen_string_literal: true

# mutation {
#   validateToken {
#     valid
#     user {
#       email
#     }
#   }
# }

class Mutations::ValidateToken < GraphQL::Schema::Mutation
  field :valid, Boolean, null: false
  field :user, Types::User, null: true
  
  def resolve()
    user = context[:current_user]
    
    {
      valid: user.present?,
      user: user,
    }
  end
end

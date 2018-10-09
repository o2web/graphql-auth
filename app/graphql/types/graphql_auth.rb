# implements GraphQLAuth in in Types::MutationType to access auth mutations

module Types::GraphqlAuth
  include GraphQL::Schema::Interface

  field :sign_in, mutation: Mutations::SignIn
  field :sign_up, mutation: Mutations::SignUp

  field :validate_token, mutation: Mutations::ValidateToken
end

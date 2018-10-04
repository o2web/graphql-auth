# implements GraphQLAuth in in Types::MutationType to access auth mutations

module Types::GraphQLAuth
  include GraphQL::Schema::Interface

  field :sign_in, mutation: Mutations::SignIn
  field :sign_up, mutation: Mutations::SignUp
end

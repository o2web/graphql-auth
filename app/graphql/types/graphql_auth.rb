# implements GraphQLAuth in in Types::MutationType to access auth mutations

module Types::GraphqlAuth
  include GraphQL::Schema::Interface

  field :sign_in, mutation: GraphQL::Auth.configuration.sign_in_mutation
  field :sign_up, mutation: GraphQL::Auth.configuration.sign_up_mutation

  field :forgot_password, mutation: GraphQL::Auth.configuration.forgot_password_mutation
  field :reset_password, mutation: GraphQL::Auth.configuration.reset_password_mutation
  
  field :update_account, mutation: GraphQL::Auth.configuration.update_account_mutation
  
end

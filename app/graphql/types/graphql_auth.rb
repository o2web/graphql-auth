# implements GraphQLAuth in in Types::MutationType to access auth mutations

module Types::GraphqlAuth
  include GraphQL::Schema::Interface

  field :sign_in, mutation: ::Mutations::Auth::SignIn

  if GraphQL::Auth.configuration.sign_up_mutation
    field :sign_up, mutation: ::Mutations::Auth::SignUp
  end

  field :forgot_password, mutation: ::Mutations::Auth::ForgotPassword
  field :reset_password, mutation: ::Mutations::Auth::ResetPassword

  field :update_account, mutation: ::Mutations::Auth::UpdateAccount

  field :validate_token, mutation: ::Mutations::Auth::ValidateToken

  if GraphQL::Auth.configuration.lock_account_mutation
    field :lock_account, mutation: Mutations::Auth::LockAccount
  end

  if GraphQL::Auth.configuration.unlock_account_mutation
    field :unlock_account, mutation: Mutations::Auth::UnlockAccount
  end
end
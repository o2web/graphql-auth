# implements GraphQLAuth in in Types::MutationType to access auth mutations

module Types::GraphqlAuth
  include GraphQL::Schema::Interface

  field :sign_in, mutation: ::Mutations::Auth::SignIn

  if GraphQL::Auth.configuration.allow_sign_up
    field :sign_up, mutation: GraphQL::Auth.configuration.sign_up_mutation.constantize
  end

  field :forgot_password, mutation: ::Mutations::Auth::ForgotPassword
  field :reset_password, mutation: ::Mutations::Auth::ResetPassword

  field :update_account, mutation: GraphQL::Auth.configuration.update_account_mutation.constantize

  field :validate_token, mutation: ::Mutations::Auth::ValidateToken

  field :sign_out, mutation: ::Mutations::Auth::SignOut

  if GraphQL::Auth.configuration.allow_lock_account
    field :lock_account, mutation: Mutations::Auth::LockAccount
  end

  if GraphQL::Auth.configuration.allow_unlock_account
    field :unlock_account, mutation: Mutations::Auth::UnlockAccount
  end

end
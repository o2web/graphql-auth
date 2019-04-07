# include this helper in GraphqlController to use context method so that current_user will be available
#
# ::GraphqlSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

module Graphql
  module LockAccountHelper
    def locked_account?(user)
      return false unless GraphQL::Auth.configuration.lock_account_mutation
      user.access_locked?
    end
  end
end

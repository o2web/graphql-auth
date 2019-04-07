# include this helper in GraphqlController to use context method so that current_user will be available
#
# ::GraphqlSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

module Graphql
  module AuthHelper
    include ::Graphql::TokenHelper
    include ::Graphql::LockAccountHelper

    def context
      {
        current_user: current_user,
        response: response
      }
    end

    # set current user from Authorization header
    def current_user
      authorization_token = request.headers['Authorization']
      return nil if authorization_token.nil?

      decrypted_token = GraphQL::Auth::JwtManager.decode(authorization_token)
      user = User.find_by id: decrypted_token['user']
      return nil if user.blank? || locked_account?(user)

      # update token if user is found with token
      generate_access_token(user, response)

      user

    # rescue expired Authorization header with RefreshToken header
    rescue JWT::ExpiredSignature
      refresh_token = request.headers['RefreshToken']
      return nil if refresh_token.nil?

      user = User.find_by refresh_token: refresh_token
      return nil if user.blank? || user.access_locked?

      generate_access_token(user, response)
      set_refresh_token(user, response)

      user
    end
  end
end

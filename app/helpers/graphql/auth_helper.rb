# include this helper in GraphqlController to use context method so that current_user will be available
#
# ::GraphqlSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

module Graphql
  module AuthHelper
    include ::Graphql::TokenHelper

    def context
      {
        current_user: current_user,
        response: response,
      }
    end

    # set current user from Authorization header
    def current_user
      return if request.headers['Authorization'].nil?

      decrypted_token = GraphQL::Auth::JwtManager.decode(request.headers['Authorization'])

      user_id = decrypted_token['user']
      user = User.find_by id: user_id  # TODO use uuid

      # update token if user is found with token
      if user.present?
        generate_access_token(user, response)
      end

      user

    # rescue expired Authorization header with RefreshToken header
    rescue JWT::ExpiredSignature
      return nil if request.headers['RefreshToken'].nil?

      user = User.find_by refresh_token: request.headers['RefreshToken']

      if user.present?
        generate_access_token(user, response)
        set_refresh_token(user, response)
      end

      user
    end


  end
end

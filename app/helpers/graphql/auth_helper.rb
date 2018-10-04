# include helper in GraphqlController to use context method so that current_user will be available
#
# ::GraphQLSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

module GraphQL
  module AuthHelper
    def context
      {
        current_user: current_user,
        response: response,
      }
    end
  
    def current_user
      return if request.headers['Authorization'].nil?
      
      decrypted_token = GraphQL::Auth::JwtManager.decode(request.headers['Authorization'])
    
      user_id = decrypted_token['user']
      User.find_by id: user_id  # TODO use uuid
    end
  end
end

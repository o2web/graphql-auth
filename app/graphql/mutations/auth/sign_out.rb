class Mutations::Auth::SignOut < GraphQL::Schema::Mutation
  include ::Graphql::TokenHelper

  argument :refresh_token,String requied: true do
    description "refresh token for expiring the user session"
  end

  field :errors, [::Types::Auth::Error], null: false
  field :success, Boolean, null: false
  field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

  def resolve(refresh_token:)
    if (refresh_token.nil? && refresh_token.empty?)
      {
        success: false,
        errors: ["refresh token is invalid"],
        user: nil
      }
    else
      user = User.find_by_refresh_token(refresh_token)
      delete_refresh_token(user)

      {
        success: true,
        errors: [],
        user: nil
      }

    end

  end

end
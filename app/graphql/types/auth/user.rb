# frozen_string_literal: true

class Types::Auth::User < GraphQL::Schema::Object
  description 'Data of a user'

  field :id, ID, null: false do
    description 'ID of the user'
  end

  field :email, String, null: false do
    description 'Email address of the user'
  end
end

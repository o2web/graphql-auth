# frozen_string_literal: true

class Types::User < Types::BaseObject
  description 'Data of a user'

  field :email, String, null: false do
    description 'Email address of the user'
  end
end

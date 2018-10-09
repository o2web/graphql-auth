# frozen_string_literal: true

class Types::Error < Types::BaseObject
  description 'Form error'

  field :field, String, null: false do
    description 'Field of the error'
  end

  field :message, String, null: false do
    description 'Error message'
  end
end

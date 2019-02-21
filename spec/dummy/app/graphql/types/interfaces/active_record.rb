# frozen_string_literal: true

module Types::Interfaces::ActiveRecord
  include Types::Interfaces::Base

  field :id, ID, null: false
end

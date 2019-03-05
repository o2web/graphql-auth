# frozen_string_literal: true

Devise.setup do |config|
  config.lock_strategy = :none
  config.unlock_keys = [:email]
  config.unlock_strategy = :none
end

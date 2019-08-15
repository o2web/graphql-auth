module Graphql
  module AccountLockHelper
    def account_locked?(user)
      return false unless GraphQL::Auth.configuration.allow_lock_account
      user.access_locked?
    end
  end
end

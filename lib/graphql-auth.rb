require 'devise'
require 'graphql-auth/configuration'
require 'graphql-auth/engine'
require 'graphql-auth/reset_password'
require 'graphql-auth/jwt_manager'

module GraphQL
  module Auth
    class << self
      attr_accessor :configuration
    end

    def self.configure
      @configuration ||= Configuration.new
      yield(configuration)
    end
  end
end



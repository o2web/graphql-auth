module GraphqlAuth
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_configuration
        template 'graphql_auth.rb.erb', 'config/initializers/graphql_auth.rb'
      end

      def rake_db
        rake("graphql_auth:install:migrations")
      end
    end
  end
end

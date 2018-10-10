module GraphqlAuth
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_configuration
        template 'initializer.rb', 'config/initializers/graphql_auth.rb'
      end
    end
  end
end

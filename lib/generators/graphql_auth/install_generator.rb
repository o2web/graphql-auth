module GraphqlAuth
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_configuration
        template 'initializer.rb', 'config/initializers/graphql_auth.rb'
        template 'add_refresh_token_to_user.rb', "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_add_refresh_token_to_user.rb"
      end
    end
  end
end

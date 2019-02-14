module GraphQL
  module Auth
    class Engine < ::Rails::Engine
      isolate_namespace GraphQL::Auth

      config.autoload_paths += Dir["#{config.root}/app/**/"]
    end
  end
end
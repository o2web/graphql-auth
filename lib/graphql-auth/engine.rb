module GraphQL
  module Auth
    class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/app/**/"]
    end
  end
end

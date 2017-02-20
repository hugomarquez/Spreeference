module Spreeference
  class Engine < ::Rails::Engine
    
    isolate_namespace Spreeference

    config.generators do |g|
      g.test_framework  :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer 'spreeference.environment', before: :load_config_initializers do |app|
      app.config.spreeference = Spreeference::Environment.new
      Spreeference::Config = app.config.spreeference.preferences
    end

    # Adds migrations to host application
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |path|
          app.config.paths["db/migrate"] << path
        end
      end
    end
    
  end
end

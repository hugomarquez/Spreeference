require 'rails/generators'
module Spreeference::Generators
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)

    desc 'Add app_configuration.rb'
    def copy_app_configuration_file
      copy_file "app_configuration.rb", "app/models/app_configuration.rb"
    end

    desc 'Add Spreeference configuration in initializers'
    def copy_configuration_file
      copy_file "spreeference.rb", "config/initializers/spreeference.rb"
    end

  end
end
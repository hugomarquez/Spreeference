module Spreeference
  class Environment
    include EnvironmentExtension

    attr_accessor :preferences

    def initialize
      @preferences = Spreeference::AppConfiguration.new
    end

  end
end
require 'spreeference/preferable_methods'
require 'spreeference/preferable'
require 'spreeference/configuration'
require 'spreeference/scoped_store'
require 'spreeference/store'
require 'spreeference/environment_extension'
require 'spreeference/environment'

module Spreeference

  def self.config
    yield(Spreeference::Config)
  end
end

require "spreeference/engine"

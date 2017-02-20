module Spreeference
  class AppConfiguration < Spreeference::Configuration
    # preference :checkbox, :boolean,  default: true
    # preference :input, :string, default:'changeme'
    # preference :number, :integer, default: 123
    # preference :list, :array, default:[]
    preference :is_ok, :string,  default:'Nice!'
  end
end
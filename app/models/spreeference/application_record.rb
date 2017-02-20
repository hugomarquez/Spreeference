module Spreeference
  class ApplicationRecord < ActiveRecord::Base
    include Spreeference::Preferable
    
    serialize :preferences, Hash
    
    after_initialize do
      if has_attribute?(:preferences) && !preferences.nil?
        self.preferences = default_preferences.merge(preferences)
      end
    end

    self.abstract_class = true 
    
  end
end
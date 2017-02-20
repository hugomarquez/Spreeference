module Spreeference
  class Preference < Spreeference::ApplicationRecord
    serialize :value
    validates :key, presence: true, uniqueness: { allow_blank: true }
  end
end
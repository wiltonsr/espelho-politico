class Theme < ActiveRecord::Base
  has_and_belongs_to_many :propositions
end
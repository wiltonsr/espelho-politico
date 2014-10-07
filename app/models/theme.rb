class Theme < ActiveRecord::Base
  has_and_belongs_to_many :propositions
  has_and_belongs_to_many :parliamentarians

 validates :id, presence: true, length: {maximum: 11}	
end

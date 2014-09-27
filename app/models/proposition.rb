class Proposition < ActiveRecord::Base
  belongs_to :Parliamentarian
  has_and_belongs_to_many :Theme
	
  validates :id, presence: true, length: {maximum: 11}
end

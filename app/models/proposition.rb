class Proposition < ActiveRecord::Base
  has_one :parliamentarian
  has_and_belongs_to_many :themes
	
  validates :id, presence: true, length: {maximum: 11}
end
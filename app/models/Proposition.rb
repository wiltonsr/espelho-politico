class Proposition < ActiveRecord::Base
  belongs_to :Parlamentarian
	
  validates :id, presence: true, length: {maximum: 11}
end
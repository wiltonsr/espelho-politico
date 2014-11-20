class Proposition < ActiveRecord::Base
  belongs_to :parliamentarian
  has_and_belongs_to_many :themes
	
  validates :id, presence: true, length: {maximum: 11}

  def self.random
    self.limit(1).offset(rand(self.count)).first
  end
end
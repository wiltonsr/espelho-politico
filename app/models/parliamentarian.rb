class Parliamentarian < ActiveRecord::Base
  has_many :propositions
  validates :id, presence: true, length: {maximum: 11}
end
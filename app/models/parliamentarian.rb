class Parliamentarian < ActiveRecord::Base
  has_and_belongs_to_many :propositions
  validates :id, presence: true, length: {maximum: 11}
end
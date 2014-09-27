class TypeProposition < ActiveRecord::Base
  validates :id, presence: true, length: {maximum: 11}    		    
end
class PropositionType < ActiveRecord::Base
  validates :id, presence: true, length: {maximum: 11}    		    
end

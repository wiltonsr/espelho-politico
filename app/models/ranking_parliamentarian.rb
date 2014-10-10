class RankingParliamentarian
	include ActiveModel::Validations
	extend ActiveModel::Naming

	attr_accessor :parliamentarian_id, :proposition_id, :propositions_count

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

end
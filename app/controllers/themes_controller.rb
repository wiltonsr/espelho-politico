class ThemesController < ApplicationController
	def index
		@themes =  Theme.all
		order_themes(@themes)
	end

	def order_themes(themes)
		themes  = themes.to_a
		themes.sort! {|b,a| a.propositions.count <=> b.propositions.count}
	end
end

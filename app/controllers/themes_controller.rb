class ThemesController < ApplicationController
	def index
		@themes =  Theme.all
		@themes = order_themes(Theme.all)
	end

	def order_themes(themes)
		themes  = themes.to_a
		themes.sort! {|b,a| a.propositions.count <=> b.propositions.count}
		themes
	end
end

class ThemesController < ApplicationController
	def index
		@themes =  Theme.all
		@themes = order_themes(Theme.all)
		@qtdOutros = count_other_themes
	end

	def order_themes(themes)
		themes  = themes.to_a
		themes.sort! {|b,a| a.propositions.count <=> b.propositions.count}
		themes
	end

	def count_other_themes
		qtdThemes = Theme.count
		qtd = 0
		for i in 10..qtdThemes
			qtd = qtd + @themes[i].propositions.count
			return qtd
		end
	end
end

class ThemesController < ApplicationController
	def index
		render "index"
	end

	def index
		@themes = theme.order :nome
	end
end
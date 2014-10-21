class RankingsController < ApplicationController
  def index
    @themes = order_themes(Theme.all)
    @selected_theme_id = (params[:theme_id])
  end

  def order_themes(themes)
		themes  = themes.to_a
  	themes.sort! {|b,a| a.propositions.count <=> b.propositions.count}
  end
end

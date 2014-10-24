class RankingsController < ApplicationController
  def index
    @themes = order_themes(Theme.all)
    if !params[:theme_id].nil?
      theme_description = params[:theme_id].split()
      theme_description.pop
      theme_description = theme_description.join(" ")
      @selected_theme_id = Theme.find_by(description: theme_description).id
    end
  end

  def order_themes(themes)
    themes  = themes.to_a
    themes.sort! {|b,a| a.propositions.count <=> b.propositions.count}
  end
end

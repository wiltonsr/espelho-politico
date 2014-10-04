class RankingsController < ApplicationController
  def index
  	@themes = Theme.all
  	@themes = order_themes(@themes)
  end   

  def order_themes(themes)
		themes  = themes.to_a
  	themes.sort! {|a,b| a.propositions.count <=> b.propositions.count}
  	themes = themes.reverse
  end
end

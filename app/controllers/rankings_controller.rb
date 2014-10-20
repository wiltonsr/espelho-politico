class RankingsController < ApplicationController
  def index
    @themes = order_themes(Theme.all)
    @parliamentarians = Parliamentarian.all
    @propositions = Proposition.all
  end

  def order_themes(themes)
		themes  = themes.to_a
  	themes.sort! {|b,a| a.propositions.count <=> b.propositions.count}
  end
end

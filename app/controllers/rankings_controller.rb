class RankingsController < ApplicationController
  def index
  	@themes = Theme.all
  	@themes = order_themes(@themes)
  

  @themes.each do |theme|
    propositions = theme.propositions.to_a
    propositions.sort! {|a,b| a.parliamentarians[0].propositions.count <=> b.parliamentarians[0].propositions.count}
    puts "=="*100
    puts theme.propositions[0].parliamentarians[0].propositions.count
    puts "=="*100
    theme.propositions = propositions
    end
  end   

  def order_themes(themes)
		themes  = themes.to_a
  	themes.sort! {|a,b| a.propositions.count <=> b.propositions.count}
  	themes = themes.reverse
  end
end
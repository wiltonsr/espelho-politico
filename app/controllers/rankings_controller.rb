class RankingsController < ApplicationController
  def index
  	@themes = Theme.all
  	@themes  = @themes.to_a
  	@themes.sort! {|a,b| a.propositions.count <=> b.propositions.count}
  	@themes = @themes.reverse
  	@themes.each do |theme|
  		puts theme.description
  		puts theme.propositions.count
  	end
  	puts "+"*100



  end  

  
end

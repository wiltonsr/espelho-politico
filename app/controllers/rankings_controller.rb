class RankingsController < ApplicationController
  def index
  	@themes = Theme.all
  	  @themes.each do |t|
  	  	puts t.description + '+' *1000
  	  end	
  end  
end

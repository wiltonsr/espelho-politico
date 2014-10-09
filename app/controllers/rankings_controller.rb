class RankingsController < ApplicationController
  def index
  	@themes = Theme.all
  	@themes = order_themes(@themes)
    get_raw_connection
    @results = @connection.query("select the.description, par.name, count(pro.id) from themes as the inner join propositions_themes as pt on pt.theme_id = the.id inner join propositions as pro on pt.proposition_id = pro.id inner join parliamentarians_propositions as pp on pp.proposition_id = pro.id inner join parliamentarians as par on par.id = pp.parliamentarian_id group by the.description, par.name order by the.description, par.name, count(pro.id) desc")
    r = @results
    r.each do |row|
      puts row
    end
    puts '+' * 100
  end

  def order_parliamentarians(themes)
    themes.each do |theme|
    propositions = theme.propositions.to_a
    propositions.sort! {|b,a| a.parliamentarians[0].propositions.count <=> b.parliamentarians[0].propositions.count}
    theme.propositions = propositions
    end
  end

  def order_themes(themes)
		themes  = themes.to_a
  	themes.sort! {|b,a| a.propositions.count <=> b.propositions.count}
  end
end
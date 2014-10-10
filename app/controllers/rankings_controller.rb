class RankingsController < ApplicationController
  def index
  	@themes = Theme.all
    parliamentarians = Parliamentarian.all

    parliamentarians.each do |parliamentarian|
      @themes.each do |theme|
        json_result = propositions_count_from_parliamentarian_per_theme(parliamentarian.id, theme.id)
      end
    end

  end

  def propositions_count_from_parliamentarian_per_theme(parliamentarian_id, theme_id)
    conn = get_raw_connection
    hash = conn.select_all(
      "SELECT parliamentarians.id as 'par_id', themes.id as 'the_id', count(*) as 'propositions' FROM `themes` " +
      "INNER JOIN `propositions_themes` ON `propositions_themes`.`theme_id` = `themes`.`id` " +
      "INNER JOIN `propositions` ON `propositions`.`id` = `propositions_themes`.`proposition_id` " +
      "INNER JOIN `parliamentarians` ON `parliamentarians`.`id` = `propositions`.`parliamentarian_id` " +
      "WHERE (parliamentarians.id = #{parliamentarian_id} and themes.id = #{theme_id}) " +
      "GROUP BY themes.id"
      )

    json_result = hash_to_json hash 
    json_result 
  end

  def hash_to_json(hash)
    hash.to_json 
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
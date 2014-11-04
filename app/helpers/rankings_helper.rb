module RankingsHelper
  def sort_parliamentarians_by_propositions_per_theme(theme_id)
    request = Proposition.joins(:themes).where("themes.id" => theme_id).select("parliamentarian_id").distinct
    request.each do |p|
     p.id = Proposition.joins(:themes).where("themes.id" => theme_id, "parliamentarian_id" => p.parliamentarian_id).count
    end
    request = Array(request).sort! {|b,a| a.id <=> b.id}
  end

  def show_name_and_number_of_propositions(theme_id, parliamentarian_id)
    name = Parliamentarian.find(parliamentarian_id).name
    number_of_propositions = Proposition.joins(:themes).where("themes.id" => theme_id, "parliamentarian_id" => parliamentarian_id).count.to_s
    name + ' (' + number_of_propositions + ')'
  end
end

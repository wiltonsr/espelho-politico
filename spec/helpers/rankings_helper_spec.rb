require 'rails_helper'

RSpec.describe RankingsHelper, :type => :helper do
  before(:each) do
    create(:parliamentarian, id: 1, name: "Eduardo")
    create(:parliamentarian, id: 2, name: "Carlos")
    create(:parliamentarian, id: 3, name: "João")
    create(:theme, id: 1, description: "Segurança")
    for i in 1..4 do
      create(:proposition, id: i, parliamentarian_id: 1)
      Proposition.find(i).themes << Theme.find_by(description: "Segurança")
    end
    for i in 5..15 do
      create(:proposition, id: i, parliamentarian_id: 2)
      Proposition.find(i).themes << Theme.find_by(description: "Segurança")
    end
    for  i in 16..20 do
      create(:proposition, id: i, parliamentarian_id: 3)
      Proposition.find(i).themes << Theme.find_by(description: "Segurança")
    end

    create(:theme, id: 2, description: "Educação")
    for i in 21..26 do
      create(:proposition, id: i, parliamentarian_id: 1)
      Proposition.find(i).themes << Theme.find_by(description: "Educação")
    end
    for i in 27..30 do
      create(:proposition, id: i, parliamentarian_id: 2)
      Proposition.find(i).themes << Theme.find_by(description: "Educação")
    end
    for i in 31..40 do
      create(:proposition, id: i, parliamentarian_id: 3)
      Proposition.find(i).themes << Theme.find_by(description: "Educação")
    end

    create(:theme, id: 3, description: "Saúde")
    for i in 41..50 do
      create(:proposition, id: i, parliamentarian_id: 1)
      Proposition.find(i).themes << Theme.find_by(description: "Saúde")
    end
    for i in 51..53 do
      create(:proposition, id: i, parliamentarian_id: 2)
      Proposition.find(i).themes << Theme.find_by(description: "Saúde")
    end
    for i in 54..60 do
      create(:proposition, id: i, parliamentarian_id: 3)
      Proposition.find(i).themes << Theme.find_by(description: "Saúde")
    end
  end

  describe "#sort_parliamentarians_by_propositions_per_theme" do
    it "returns parliamentarians sort correctly" do
      p_sorted = helper.sort_parliamentarians_by_propositions_per_theme(1)
      
      expect(p_sorted.first.parliamentarian_id).to eq(2)
      expect(p_sorted.second.parliamentarian_id).to eq(3)
      expect(p_sorted.third.parliamentarian_id).to eq(1)
    end
  end

  describe "#show_name_and_number_of_propositions" do
    it "returns the parliamentarian with quantity of propositions in a string" do
      

      string1 = helper.show_name_and_number_of_propositions(1, 1)
      string2 = helper.show_name_and_number_of_propositions(1, 2)
      string3 = helper.show_name_and_number_of_propositions(1, 3)
      string4 = helper.show_name_and_number_of_propositions(2, 1)
      string5 = helper.show_name_and_number_of_propositions(2, 2)
      string6 = helper.show_name_and_number_of_propositions(2, 3)
      string7 = helper.show_name_and_number_of_propositions(3, 1)
      string8 = helper.show_name_and_number_of_propositions(3, 2)
      string9 = helper.show_name_and_number_of_propositions(3, 3)

      expect(string1).to eq("Eduardo (4)")
      expect(string2).to eq("Carlos (11)")
      expect(string3).to eq("João (5)")
      expect(string4).to eq("Eduardo (6)")
      expect(string5).to eq("Carlos (4)")
      expect(string6).to eq("João (10)")
      expect(string7).to eq("Eduardo (10)")
      expect(string8).to eq("Carlos (3)")
      expect(string9).to eq("João (7)")
    end
  end
end
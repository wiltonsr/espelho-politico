require 'rails_helper'

RSpec.describe QuizController, :type => :controller do
  before(:each) do
    create(:theme, id: 1, description: "Segurança")
    for i in 1..5 do
      create(:proposition, id: i)
      Proposition.find(i).themes << Theme.find_by(description: "Segurança")
    end
  end

  describe "GET index" do
    it "render the index correctly" do
      get :index
      expect(response).to render_template("index")
    end

    it "return @proposition correctly" do
      expect(assigns(:proposition)).not_to eq([])
    end
  end

  describe "#randomize_propositions" do
    it "expects to shuffle propositions" do
      propositions = controller.randomize_propositions(Proposition.all.select(:id))

      expect(propositions).not_to eq(Proposition.all.select(:id))
    end
  end

end
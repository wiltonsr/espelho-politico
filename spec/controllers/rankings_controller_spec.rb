require 'rails_helper'

RSpec.describe RankingsController, :type => :controller do

  describe "GET index" do
    describe "with database data" do
      it "Assigns themes to appear on index" do
        themes = []
        themes << Theme.new(:id => 532, :description => "saude")
        themes << Theme.new(:id => 123, :description => "segurança")
        themes << Theme.new(:id => 521, :description => "educacao")
      
        theme = controller.order_themes(@themes)
        expect {
          (assigns(:themes)).to match_array(theme)}
      end
    end
  end
end
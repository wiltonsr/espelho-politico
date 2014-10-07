require 'rails_helper'

RSpec.describe RankingsController, :type => :controller do

  describe "GET index" do
    describe "with database data" do
      it "Assigns themes to appear on index" do
        themes = []
        themes << Theme.new(:id => 532, :description => "Saúde")
        themes << Theme.new(:id => 123, :description => "Educação")
        themes << Theme.new(:id => 521, :description => "Segurança")
      
        theme = controller.order_themes(@themes)
        expect {
          (assigns(:themes)).to match_array(theme)}
      end
    end
  end
  describe "GET index" do
    describe "with database data" do
      it "Assigns parliamentarians to appear on index" do
        parliamentarians = []
        parliamentarians << Parliamentarian.new(:id => 245, :registry => '257', 
          :condition => "eleito", :name => "Jose Genuino", :url_photo => "url/photo/parlamentar", 
          :state => "Sergipe", :party => "PCdoB", 
          :phone => "9999-9999", :email => "parlamentar@gmail.com", :cabinet => 234)
        parliamentarians << Parliamentarian.new(:id => 134, :registry => '258', 
          :condition => "eleito", :name => "Jose Genuino", :url_photo => "url/photo/parlamentar", 
          :state => "Sergipe", :party => "PCdoB", 
          :phone => "9999-9999", :email => "parlamentar@gmail.com", :cabinet => 234)
        parliamentarians << Parliamentarian.new(:id => 823, :registry => '255', 
          :condition => "eleito", :name => "Jose Genuino", :url_photo => "url/photo/parlamentar", 
          :state => "Sergipe", :party => "PCdoB", 
          :phone => "9999-9999", :email => "parlamentar@gmail.com", :cabinet => 234)
        
        theme = controller.order_themes(@themes)
        #parliamentarian = controller.order_parliamentarians(@theme)
        expect {
          (assigns(:parliamentarians)).to match_array(parliamentarian)}
      end
    end
  end




end

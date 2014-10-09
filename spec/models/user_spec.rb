require 'rails_helper'
  
RSpec.describe User, :type => :models do

  let(:valid_attributes) {{
    :name => "Jose",
    :email => "jose@email.com", 
    :username => "zejose",
    :password => "12345",
    }}

  let(:invalid_attributes) {{
    :name => " ",
    :email => "aiushdaaas",
    :username => "1234",
    :password => "jose",
    }}

  describe 'POST create' do 
    describe 'with valid attributes' do 
      it "valuate the information" do
        user = User.new(valid_attributes)
        expect(user).to be_valid
      end      
    end
  end
  describe 'POST create' do
    describe 'with invalid attributes' do
      it "doesn`t valuate the information" do
      user = User.new(invalid_attributes)
      expect(user).to be_invalid
      end
    end
  end
end
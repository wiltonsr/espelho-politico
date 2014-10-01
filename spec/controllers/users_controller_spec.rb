require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  let(:valid_attributes) {{
    :name => "Jose",
    :email => "jose@email.com", 
    :password => "123456",
    :username => "zejose",
    :password_confirmation => "123456"
    }}

  let(:invalid_attributes) {{
    :name => " ",
    :email => "aiushdaaas",
    :password => "1234",
    :username => "jose",
    :password_confirmation => "123456"
    }}
   
   let(:valid_session) {{}}
  
  describe "POST create" do
    describe "with valid_attributes" do
      it "creates a new user" do
        expect {
          post :create, {:user => valid_attributes}, valid_session}.to change(User, :count).by(1)
      end
    end
  end
end
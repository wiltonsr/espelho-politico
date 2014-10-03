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

  let(:new_attributes) {{
    :name => "Jailson",
    :email => "jailson@email.com",
    :password => "654321",
    :username => "Jailson",
    :password_confirmation => "654321"
    }}
   
   let(:valid_session) {{}}
  
  describe "POST create" do
    describe "with valid_attributes" do
      it "Creates a new user" do
        expect {
          post :create, {:user => valid_attributes}, valid_session}.to change(User, :count).by(1)
      end
    end
  end

  # describe "PUT update" do
  #   describe "with new_attributes" do
  #     it "Update the user informations" do
  #       expect {
  #         post :update, {:user => new_attributes}, valid_session}.to change
  #           (User.find_by_email ("jailson@email.com"), :updated_at)
  #     end
  #   end
  # end

  describe "DELETE destroy" do
    it "Deletes the selected user" do
      expect {
        delete :destroy, {:user => valid_attributes}, valid_session}.to change(User, :count).by(-1)
    end
  end
end
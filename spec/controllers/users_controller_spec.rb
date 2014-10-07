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
      it "Creates a new user" do
        expect {
          post :create, {:user => valid_attributes}, valid_session}.to change(User, :count).by(1)
      end
    end
  end

  describe "POST create" do
    describe "with invalid_attributes" do
      it "doesn`t create a new user" do
        expect {
          post :create, {:user => invalid_attributes}, valid_session}.to change(User, :count).by(0)
      end
    end
  end

  describe "GET new" do
    it "Assigns a new user as @user" do
      get :new, {}, valid_session
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "PUT update" do
    describe "with valid_attributes" do
      let(:valid_attributes) {{
        :name => "Jose",
        :email => "jose@email.com", 
        :password => "123456",
        :username => "zejose",
        :password_confirmation => "123456"
      }}
      it "Update the user informations" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}
        user.reload
      end
      it "Assigns the requested user to be @user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end
    end
  end

  describe "DELETE destroy" do
    it "Deletes the selected user" do
      user = User.create! valid_attributes
      expect {
        delete :destroy, {:id => user.to_param}, valid_session}.to change(User, :count).by(-1)
    end
  end 
end
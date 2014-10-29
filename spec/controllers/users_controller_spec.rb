require 'rails_helper'

# RSpec.describe UsersController, :type => :controller do

#   let(:valid_attributes) {{
#     :name => "Jose",
#     :email => "jose@email.com", 
#     :password => "123456",
#     :username => "zejose",
#     :password_confirmation => "123456"
#     }}

#   let(:invalid_attributes) {{
#     :name => " ",
#     :email => "aiushdaaas",
#     :password => "1234",
#     :username => "jose",
#     :password_confirmation => "123456"
#     }}
   
#    let(:valid_session) {{}}

#    describe "POST create" do
#     describe "with valid attributes" do
#       it "saves the new user" do
#         expect{
#           post :create, {:user => valid_attributes}, valid_session}.to change(User, :count).by(1)
#       end
#       it "send an confirmation email" do
#         post :create, {:user => valid_attributes}, valid_session  
#         response.should send_activation_email
#       end
#       it "redirects to the root" do
#         post :create, {:user => valid_attributes}, valid_session  
#         response.should redirect_to(root_path)
#       end        
#     end
#   end

#   describe "POST create" do
#     describe "with invalid_attributes" do
#       it "doesn't creates a new user" do
#         expect{
#           post :create, {:user => invalid_attributes}, valid_session}.to change(User, :count).by(0)
#       end
#     end
#   end

#   describe "GET new" do
#     it "Assigns a new user as @user" do
#       get :new, {}, valid_session
#       expect(assigns(:user)).to be_a_new(User)
#     end
#   end

#   describe "PUT update" do
#     describe "with valid_attributes" do
#       let(:valid_attributes) {{
#         :name => "Jose",
#         :email => "jose@email.com", 
#         :password => "123456",
#         :username => "zejose",
#         :password_confirmation => "123456"
#       }}
#       it "update the user informations" do
#         user = User.create! valid_attributes
#         put :update, {:id => user.to_param, :user => valid_attributes}
#         user.reload
#       end
#       it "assigns the requested user to be @user" do
#         user = User.create! valid_attributes
#         put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
#         expect(assigns(:user)).to eq(user)
#       end
#       it "redirects to the users" do
#         user = User.create! valid_attributes
#         put :update, {:id => user.to_param, :user => valid_attributes}, valid_session  
#         response.should redirect_to(users_path)
#       end 
#     end
#   end

#   describe "DELETE destroy" do
#     it "deletes the current user" do
#       user = User.create! valid_attributes
#       expect {
#         delete :destroy, {:id => user.to_param}, valid_session}.to change(User, :count).by(-1)
#     end
#     it "redirects to the users" do
#       user = User.create! valid_attributes
#       delete :destroy, {:id => user.to_param}, valid_session
#       response.should redirect_to(users_path)
#     end 
#   end 
# end
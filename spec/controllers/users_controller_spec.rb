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
    end
  end

#   describe "DELETE destroy" do
#     it "Deletes the selected user" do
#       expect {
#         delete :destroy, {:user => valid_attributes}, valid_session}.to change(User, :count).by(-1)
#     end
#   end Ao invés de tentar subtrair um do banco de dados, substituir os valores dos parâmetros por nil e depois disso remover
end
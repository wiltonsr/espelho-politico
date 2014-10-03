require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
  end

  test "should create user" do
    post :create, :user=>{
      :name=>"usuario", 
      :email=>"usuariou@email.com", 
      :password=>"123456", 
      :password_confirmation=>"123456", 
      :username=>"usuario"
    }

    assert_equal "usuario@email.com", User.last.email
  end
end
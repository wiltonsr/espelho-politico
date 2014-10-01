require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
  end

  test "should create user" do
    post :create, :user=>{
      :name=>"Ola Mundo", 
      :email=>"umemail@qualquer.com", 
      :password=>"abderf", 
      :password_confirmation=>"abderf", 
      :username=>"huehueuhe brbr"
    }

    assert_equal "umemail@qualquer.com", User.last.email
  end
end
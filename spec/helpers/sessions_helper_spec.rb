require 'rails_helper'

RSpec.describe SessionsHelper, :type => :helper do

  let(:valid_attributes) {{
    :name => "Jose",
    :email => "jose@email.com", 
    :password => "123456",
    :username => "zejose",
    :password_confirmation => "123456"
    }}

  it "expects to return true if the current user == @user}" do
    user = User.create! valid_attributes
    current_user=User
    current_user(User)
    expect(current_user?).to be(true)
  end

  it "expects to return false if the current user signs out" do
    user = User.create! valid_attributes
    user=(@user)
    sign_out
    expect(signed_in?).to be(false)
  end
end
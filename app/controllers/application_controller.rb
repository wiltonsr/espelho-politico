class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  def get_raw_connection
  	if ENV['RAILS_ENV'].eql? "development"
  		database = "ep_dev"
  	elsif ENV['RAILS_ENV'].eql "production"
  		database = "ep_prod"
  	else
  		database = "ep_test"
  	end
    @connection = Mysql2::Client.new(:host => "localhost", :username => "root", :database => database)
  end
end

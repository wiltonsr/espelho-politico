class ProfileController < ApplicationController
  def index
  end

  def send_id
  	@parliamentarian = Parliamentarian.find(params[:parliamentarian_id])
  end

  def show
  	@parliamentarian = Parliamentarian.find(params[:id])
  end
end
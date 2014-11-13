class ProfileController < ApplicationController
  def index
    @parliamentarian = Parliamentarian.find(params[:parliamentarian_id])
    p = @parliamentarian
    @prop_parliamentarian = propositions_parliamentarians(p.id)
  end

  def send_id
  	@parliamentarian = Parliamentarian.find(params[:parliamentarian_id])
  end

  def show
  	@parliamentarian = Parliamentarian.find(params[:id])
  end
end
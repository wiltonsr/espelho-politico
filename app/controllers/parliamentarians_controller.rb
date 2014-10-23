class ParliamentariansController < ApplicationController
  def index
    @parliamentarians = Parliamentarian.search(params[:search])
  end

  def show
    @parliamentarian = Parliamentarian.find(params[:id])
  end

  def new
    @parliamentarian = Parliamentarian.new
  end
end

class ParliamentariansController < ApplicationController
  def index
    @parliamentarians = Parliamentarian.search(params[:search])
    #@parliamentarians = Parliamentarian.all
    # @parliamentarians = order_parliamentarians(@parliamentarians)
  end

  # def order_parliamentarians(parliamentarians)
  #    parliamentarians  = parliamentarians.to_a
  #    parliamentarians.sort! {|b,a| a.propositions.count <=> b.propositions.count}
  # end

  def show
    @parliamentarian = Parliamentarian.find(params[:id])
  end

  def new
    @parliamentarian = Parliamentarian.new
  end
end

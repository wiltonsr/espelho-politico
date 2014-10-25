class ParliamentariansController < ApplicationController
  def index
    @parliamentarians = Parliamentarian.search(params[:search])
    @ordened_states = order_states(Parliamentarian.select(:state).distinct)

    @parliamentarians.each do |p|
      p.state
    end
  end

  def show
    @parliamentarian = Parliamentarian.find(params[:id])
  end

  def new
    @parliamentarian = Parliamentarian.new
  end

  def order_states(state)
    state  = state.to_a
    state.sort! {|a,b| a.state <=> b.state}
  end
end

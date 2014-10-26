class ParliamentariansController < ApplicationController
  def index
    @parliamentarians = Parliamentarian.search(params[:search])
    @ordened_states = order_states(Parliamentarian.select(:state).distinct)
    @ordened_partys = order_partys(Parliamentarian.select(:party).distinct)

    # @parliamentarians.each do |p|
    #   p.state
    # end
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

  def order_partys(party)
    party  = party.to_a
    party.sort! {|a,b| a.party <=> b.party}
  end

  def get_by_state(state)
    @parlamentarians_by_state = Parliamentarian.select(:state)
  end
end

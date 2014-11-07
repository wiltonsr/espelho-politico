class ParliamentariansController < ApplicationController
  def index
    @parliamentarians = Parliamentarian.search(params[:search])
    @ordened_states = order_states(Parliamentarian.select(:state).distinct)
    @ordened_partys = order_partys(Parliamentarian.select(:party).distinct)
  end

  def show
    parliamentarian_id = Integer(params[:id]) rescue nil
    unless parliamentarian_id.nil? then
      @parliamentarian = Parliamentarian.find(params[:id])
      render nothing: true
    end
    render nothing: true
  end

  def new
    @parliamentarian = Parliamentarian.new
    render nothing: true
  end

  def order_states(state)
    state  = state.to_a
    state.sort! {|a,b| a.state <=> b.state}
  end

  def order_partys(party)
    party  = party.to_a
    party.sort! {|a,b| a.party <=> b.party}
  end

  def parliamentarians_per_state
    @selected_state = Parliamentarian.where(params[:state])
  end

  def parliamentarians_per_party(party)
    @selected_party = Parliamentarian.where(:party)
  end
end

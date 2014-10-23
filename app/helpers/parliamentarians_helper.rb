module ParliamentariansHelper
  def parlamentarians_by_state(state)
    Parliamentarian.where(state)
  end
end
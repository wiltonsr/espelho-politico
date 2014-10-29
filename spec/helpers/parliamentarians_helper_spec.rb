require 'rails_helper'

RSpec.describe ParliamentariansHelper, :type => :helper do
  it "expects to find all the parlamentarians of one state" do
    Parliamentarian.where("df") == parlamentarians_by_state("df")
  end
end
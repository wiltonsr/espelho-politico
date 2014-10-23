require 'rails_helper'

RSpec.describe ParliamentariansController, :type => :controller do

  describe "GET index" do
    it "assigns @parliamentarians as parliamentarian"  do
      Parliamentarian.name == Parliamentarian.search("Jose")
    end
  end
end
 
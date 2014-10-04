class CreatePropositionsParliamentarians < ActiveRecord::Migration
  def change
    create_table :propositions_parliamentarians do |t|
      t.belongs_to :propositions
      t.belongs_to :parliamentarians
    end
  end
end

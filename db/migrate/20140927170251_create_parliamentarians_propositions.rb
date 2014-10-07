class CreateParliamentariansPropositions < ActiveRecord::Migration
  def change
    create_join_table :parliamentarians, :propositions do |t|
      t.index :parliamentarian_id
      t.index :proposition_id
    end
  end
end

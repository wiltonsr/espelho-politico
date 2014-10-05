class CreatePropositionsThemes < ActiveRecord::Migration
  def change
    create_join_table :propositions, :themes do |t|
      t.index :proposition_id
      t.index :theme_id
    end
  end
end

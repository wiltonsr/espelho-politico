class CreatePropositionsThemes < ActiveRecord::Migration
  def change
    create_table :propositions_themes do |t|
      t.belongs_to :propositions
      t.belongs_to :themes
    end
  end
end

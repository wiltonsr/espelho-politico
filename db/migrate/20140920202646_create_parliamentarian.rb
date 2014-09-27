class CreateParliamentarian < ActiveRecord::Migration
  def change
    create_table :parliamentarians do |t|
      t.string  :registry
      t.string  :condition
      t.string  :name
      t.string  :url_photo
      t.string  :state
      t.string  :party
      t.string  :phone
      t.string  :email
      t.integer :cabinet
    end
    add_index :parliamentarians, :name
    add_index :parliamentarians, :registry
  end
end

class CreateParliamentarian < ActiveRecord::Migration
  def change
    create_table :parliamentarian do |t|
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
    add_index :parliamentarian, :name
    add_index :parliamentarian, :registry
  end
end
class CreateTheme < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string  :description
    end
    add_index(
      :themes,
      [:description],
      unique: true
    )
  end
end

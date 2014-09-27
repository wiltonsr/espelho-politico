class CreateProposition < ActiveRecord::Migration
  def change
    create_table :proposition do |t|
      t.integer      :year
      t.integer      :number
      t.text         :amendment
      t.text         :explanation
      t.string       :theme
      t.references   :Parliamentarian
      t.references   :TypeProposition
      t.date         :presentation_date
      t.string       :situation
      t.string       :content_link
    end
    add_index(
      :proposition, 
      [:number, :year, :Parliamentarian_id],
      unique: true
    )
  end
end

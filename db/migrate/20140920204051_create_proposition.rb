class CreateProposition < ActiveRecord::Migration
  def change
    create_table :propositions do |t|
      t.integer      :year
      t.integer      :number
      t.text         :amendment
      t.text         :explanation
      t.string       :proposition_types
      t.date         :presentation_date
      t.string       :situation
      t.string       :content_link
    end
    add_index(
      :propositions,
      [:number, :year, :proposition_types],
      unique: true
    )
  end
end

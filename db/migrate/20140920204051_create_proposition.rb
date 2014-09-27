class CreateProposition < ActiveRecord::Migration
  def change
    create_table :propositions do |t|
      t.integer      :year
      t.integer      :number
      t.text         :amendment
      t.text         :explanation
      t.references   :themes
      t.references   :parliamentarians
      t.references   :proposition_types
      t.date         :presentation_date
      t.string       :situation
      t.string       :content_link
    end
    add_index(
      :propositions,
      [:number, :year, :parliamentarians_id],
      unique: true
    )
  end
end

class CreateTypeProposition < ActiveRecord::Migration
  def change
    create_table	:proposition_types do |t|
      t.string		:acronym      
      t.string		:description
    end
  end
end

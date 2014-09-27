class CreateTypeProposition < ActiveRecord::Migration
  def change
    create_table	:type_proposition do |t|
      t.string		:acronym      
      t.string		:description
    end
  end
end

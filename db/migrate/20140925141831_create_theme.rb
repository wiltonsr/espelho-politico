class CreateTheme < ActiveRecord::Migrate
  def change
    create_table :theme do |t|
    t.string 	:description
  end
end

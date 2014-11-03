# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


	Theme.create(:id => 1, :description => "Educação")
	Theme.create(:id => 2, :description => "Saúde")
	Theme.create(:id => 3, :description => "Segurança")
	Theme.create(:id => 4, :description => "Lazer")

	Proposition.create(:id => 1)
	Proposition.create(:id => 2)
	Proposition.create(:id => 3)
	Proposition.create(:id => 4)
	Proposition.create(:id => 5)
	Proposition.create(:id => 6)
	Proposition.create(:id => 7)
	Proposition.create(:id => 8)
	Proposition.create(:id => 9)
	Proposition.create(:id => 10)
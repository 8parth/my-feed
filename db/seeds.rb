# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
agent = Mechanize.new
page = agent.get("http://showrss.info/?cs=feeds")
form = page.forms[0]

options= form.fields[1].options


options.each do |option|
	Show.create(name: option.text, value: option.value)
end
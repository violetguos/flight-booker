# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ActiveRecord::Base.transaction do
#   Flight.destroy_all
#   Airport.destroy_all

# end


Airport.create([{code: 'SFO'}, {code: 'LAX'}])
Flight.create([{from_airport_id: Airport.first.id, to_airport_id: Airport.last.id}])

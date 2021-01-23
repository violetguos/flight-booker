# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  Flight.destroy_all
  Airport.destroy_all
  Passenger.destroy_all
  Booking.destroy_all
end

AIRPORTS = %w[SFO LAX JFK]

AIRPORTS.each do |a|
  Airport.create(code: a)
end

# Date.new(2021, 5, 1).upto(Date.new(2021, 9, 30)).each do |date|

Flight.create([{ from_airport_id: Airport.all[0].id, to_airport_id: Airport.all[1].id,
                 takeoff_day: Date.new(2021, 5, 1) },
               { from_airport_id: Airport.all[0].id, to_airport_id: Airport.all[1].id,
                 takeoff_day: Date.new(2021, 5, 2) },
               { from_airport_id: Airport.all[1].id, to_airport_id: Airport.all[2].id,
                 takeoff_day: Date.new(2021, 5, 3) },
               { from_airport_id: Airport.all[2].id, to_airport_id: Airport.all[1].id,
                 takeoff_day: Date.new(2021, 5, 7) }])
p = Passenger.create(first_name: 'Michael', last_name: 'Scott', email: 'michael@dm.com')
Booking.create(flight_id: Flight.first.id, passengers: [p])

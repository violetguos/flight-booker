# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#  rake db:seed (locally)
# what about heroku remote????
#   
require 'faker'
require 'date'
require 'time'

ActiveRecord::Base.transaction do
  Airport.destroy_all
  Flight.destroy_all
  Passenger.destroy_all
  Booking.destroy_all
end

AIRPORTS = { 'ATL' => %w[Atlanta GA],
             'LAX' => ['Los Angeles', 'CA'],
             'JFK' => ['New York', 'NY'],
             'SFO' => ['San Francisco', 'CA'],
             'ORD' => %w[Chicago IL],
             'DFW' => %w[Dallas TX] }

AIRPORTS.each do |code, location|
  Airport.create(code: code, city: location[0], state: location[1])
end

Airport.all.each do |air|
  from_airport = air
  to_airport = Airport.all.sample
  to_airport = Airport.all.sample until to_airport != from_airport
  time = Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 200, format: :default)
  duration = rand(100...300)  # in minutes
  Flight.create({ from_airport_id: from_airport.id, to_airport_id: to_airport.id, takeoff: time, duration: duration })
end

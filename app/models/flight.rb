class Flight < ApplicationRecord
  belongs_to :from_airport, class_name: 'Airport'
  belongs_to :to_airport, class_name: 'Airport'
  has_many :bookings, dependent: :destroy

  def self.search(search)
    if search.empty?
      nil
    elsif search
      flights = Flight.all
      flights = flights.where('from_airport_id = ?', search[:from_airport_id]) if search[:from_airport_id]
      flights = flights.where('to_airport_id = ?', search[:to_airport_id]) if search[:to_airport_id]
      flights = flights.where(takeoff: Date.parse(search[:takeoff]).all_day) if search[:takeoff]

    end
    flights
  end
end

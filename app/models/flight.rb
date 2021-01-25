class Flight < ApplicationRecord
  belongs_to :from_airport, class_name: 'Airport'
  belongs_to :to_airport, class_name: 'Airport'
  has_many :bookings, dependent: :destroy

  def self.search(search)
    if search.empty?
      nil
    elsif search
      flights = Flight.all
      flights = Flight.where('from_airport_id = ?', search[:from_airport_id]) if search[:from_airport_id]
      flights = Flight.where('to_airport_id = ?', search[:to_airport_id]) if search[:to_airport_id]
      flights = Flight.where('takeoff_day = ?', search[:takeoff_day]) if search[:takeoff_day]
    end
    flights
  end
end

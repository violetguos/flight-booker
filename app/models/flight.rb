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
      # flights = Flight.where('takeoff >= ?', search[:takeoff] + ' 00:00:00 +0000') if search[:takeoff]
      if search[:takeoff]
        flights = Flight.where('takeoff <= ? and takeoff >= ?', search[:takeoff] + ' 23:59:59 +0000',
                               search[:takeoff] + ' 00:00:00 +0000')
      end

    end
    flights
  end
end

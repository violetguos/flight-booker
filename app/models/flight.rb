class Flight < ApplicationRecord
  belongs_to :from_airport, class_name: 'Airport'
  belongs_to :to_airport, class_name: 'Airport'
  has_many :bookings
  def self.search(search)
    if search
      flights = Flight.where(['from_airport_id = ? and to_airport_id = ?', search[:from_airport_id],
                              search[:to_airport_id]])
    end
    flights
  end
end

class Flight < ApplicationRecord
  belongs_to :from_airport, class_name: 'Airport'
  belongs_to :to_airport, class_name: 'Airport'
  has_many :bookings, dependent: :destroy

  def self.search(search)
    if search.empty?
      nil
    elsif search
      flights = Flight
                .from_airport(search[:from_airport_id])
                .to_airport(search[:to_airport_id])
                .on_date(search[:takeoff])
      flights = flights.page(search[:page]).per(100) # if using Kaminari
    end
    flights
  end
end

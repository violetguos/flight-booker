class Flight < ApplicationRecord
  belongs_to :from_airport, class_name: "Airport"
  belongs_to :to_airport, class_name: "Airport"

  def self.search(search)
    if search
      puts search[:from_airport_id]
      flights = Flight.where("from_airport_id", search[:from_airport_id]) if search[:from_airport_id].present?
    end
    return flights
  end
end

class Flight < ApplicationRecord
  belongs_to :from_airport, class_name: "Airport"
  belongs_to :to_airport, class_name: "Airport"

  def self.search(search)
    if search
      flight = Flight.find_by(from_airport: search)
    end
  end
end

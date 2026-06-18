# not migrated due to outdated gems
class AddIndexesToFlights < ActiveRecord::Migration[7.0]
  def change
    add_index :flights, :from_airport_id
    add_index :flights, :to_airport_id
    add_index :flights, :takeoff
    # example for composite index to improve performance
    add_index :flights, %i[from_airport_id to_airport_id takeoff]
  end
end

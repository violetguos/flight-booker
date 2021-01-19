class CreateFlights < ActiveRecord::Migration[6.1]
  def change
    create_table :flights do |t|
      t.date :takeoff_day
      t.time :takeoff_time
      t.integer :duration
      t.references :from_airport, foreign_key: { to_table: :airports } 
      t.references :to_airport,   foreign_key: { to_table: :airports } 
      t.timestamps
    end
  end
end

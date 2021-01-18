class CreateFlights < ActiveRecord::Migration[6.1]
  def change
    create_table :flights do |t|
      t.date :takeoff_day
      t.time :takeoff_time
      t.integer :duration
      t.references :from_airport, references: :airport
      t.references :to_airport,  references: :airport
      t.timestamps
    end
  end
end

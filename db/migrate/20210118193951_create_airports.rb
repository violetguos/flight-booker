class CreateAirports < ActiveRecord::Migration[6.1]
  def change
    create_table :airports do |t|
      t.string :code, null: false
      t.string :city
      t.string :state
      t.timestamps
    end
  end
end

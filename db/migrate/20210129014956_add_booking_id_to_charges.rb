class AddBookingIdToCharges < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :booking_id, :integer
  end
end

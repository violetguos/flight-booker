class CreateCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :charges do |t|
      t.belongs_to :booking
      t.timestamps
    end
  end
end

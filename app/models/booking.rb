class Booking < ApplicationRecord
  belongs_to :flight
  belongs_to :charge
  has_many :passengers, dependent: :destroy
  accepts_nested_attributes_for :passengers, allow_destroy: true
end

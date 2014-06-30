class Address < ActiveRecord::Base
  include ValidationState

  attr_accessible :city, :state, :street, :zip

  belongs_to :location, touch: true

  validates :street,
            :city,
            :state,
            :zip,
            presence: { message: "can't be blank for Address" },
            if: :validate?

  validates :state,
            length: {
              maximum: 2,
              minimum: 2,
              message: 'Please enter a valid 2-letter state abbreviation'
            },
            if: :validate?

  validates :zip, zip: true, if: :validate?

  auto_strip_attributes :street, :city, :state, :zip, squish: true
end

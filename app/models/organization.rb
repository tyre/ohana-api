class Organization < ActiveRecord::Base
  include ValidationState
  PROTOCOL_REGEX = URI::regexp(["http", "https"])
  URI_REGEX = /\A#{PROTOCOL_REGEX}.+\..*\z/

  default_scope { order("id DESC") }

  attr_accessible :name, :urls

  has_many :locations, dependent: :destroy
  # accepts_nested_attributes_for :locations
  validates_associated :locations

  validates :name, presence: true

  # Custom validation for values within arrays.
  # For example, the urls field is an array that can contain multiple URLs.
  # To be able to validate each URL in the array, we have to use a
  # custom array validator. See app/validators/array_validator.rb
  validates :urls, array: {
    format: { with: URI_REGEX,
              message: "is not a valid URL", allow_blank: true } }

  serialize :urls, Array

  auto_strip_attributes :name
  auto_strip_attributes :urls, reject_blank: true, nullify: false

  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :domain_name]
    ]
  end

  def domain_name
    URI.parse(urls.first).host.gsub(/^www\./, "") if urls.present?
  end

  after_save :touch_locations

  private

  def touch_locations
    locations.find_each(&:touch)
  end
end

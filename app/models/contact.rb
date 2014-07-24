class Contact < ActiveRecord::Base
  include ValidationState

  default_scope { order('id ASC') }

  attr_accessible :email, :extension, :fax, :name, :phone, :title

  belongs_to :location, touch: true

  validates :name, :title, presence: { message: "can't be blank for Contact" }
  validates :email, email: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  validates :fax, fax: true, allow_blank: true

  validates_presence_of :name, message: "can't be blank for Contact"
=begin
  validates_formatting_of :email,
                          with: /.+@.+\..+/i,
                          allow_blank: true, message: '%{value} is not a valid email'

  validates_formatting_of :phone,
                          using: :us_phone,
                          allow_blank: true,
                          message: '%{value} is not a valid US phone number'

  validates_formatting_of :fax,
                          using: :us_phone,
                          allow_blank: true,
                          message: '%{value} is not a valid US fax number'
=end
  include Grape::Entity::DSL
  entity do
    expose :id
    expose :name, unless: ->(o, _) { o.name.blank? }
    expose :title, unless: ->(o, _) { o.title.blank? }
    expose :phone, unless: ->(o, _) { o.phone.blank? }
    expose :email, unless: ->(o, _) { o.email.blank? }
    expose :fax, unless: ->(o, _) { o.fax.blank? }
  end
  auto_strip_attributes :email, :extension, :fax, :name, :phone, :title, squish: true
end

class ImportJob < ActiveRecord::Base
	belongs_to :admin
  
  attr_accessible :url
  
  validates :url, presence: true, format: { with: /\A(http|https):\/\// }
	
end
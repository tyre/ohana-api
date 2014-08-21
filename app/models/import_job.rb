class ImportJob < ActiveRecord::Base
  include AASM

  aasm do
    state :new_job, initial: true
    state :started_job
    state :finished_job
    
    event :start_job do
      transitions from: :new_job, to: :started_job
    end
    event :finish_job do
      transitions from: :started_job, to: :finished_job
    end
  end
    
	belongs_to :admin
  has_and_belongs_to_many :organizations
  
  attr_accessible :url
  
  validates :url, presence: true, format: { with: /\A(http|https):\/\// }
  
  after_create :perform
  
  def perform
    start_job!
    tempfile = nil
    begin
      tempfile = Tempfile.new(['data', File.extname(url)])
      tempfile.binmode
      tempfile.write open(url).read
      tempfile.size # flushes IO buffer
      tempfile.rewind
      firstchar = tempfile.readchar
      tempfile.rewind
      if firstchar == '['
        data = tempfile.read
        records = JSON.parse(data)
        records.each do |record|
          save_record(record)
        end
      else
        tempfile.each do |line|
          record = JSON.parse(line)
          save_record(record)
        end
      end
    rescue
      puts $!.backtrace
      puts $!
    ensure
      if tempfile
        tempfile.close
        tempfile.unlink
      end
    end
    finish_job!
  end
  handle_asynchronously :perform
  
  def save_record(record)
    params = record.except('locations')
    org = Organization.new params
    sanitized = org.send :sanitize_for_mass_assignment, params
    rejected = []
    params.each do |k, v|
      rejected << k unless sanitized.has_key?(k)
    end
    puts rejected.inspect
    if org.save(validate: false)
      locs = record['locations']
      locs.each do |location|
        location = Location.new(location.merge(organization_id: org.id))
        location.save(validate: false)
        sleep 0.2 # to prevent Geocoder rate limit exception
      end unless locs.nil?
      organizations << org
    end
  end
	
end

require 'json'
require 'open-uri'

task :setup_db => [
  :create_categories,
  :load_data
  ]
  

task :load_data => :environment do
  file = ENV['FILE'] || "data/sample_data.json"

  puts "===> Populating the #{Rails.env} DB with #{file}..."
  puts "===> Depending on the size of your data, this can take several minutes..."
  
  def parse(data_item)
    org = Organization.create!(data_item.except("locations"))

    locs = data_item["locations"]
    locs.each do |location|
      location = Location.new(location.merge(organization_id: org.id))
      unless location.save
        name = location["name"]
        invalid_records = {}
        invalid_records[name] = {}
        invalid_records[name]["errors"] = location.errors
        File.open("data/invalid_records.json","a") do |f|
          f.puts(invalid_records.to_json)
        end
      end
      # Uncomment line 32 below if you get Geocoder::OverQueryLimitError
      # You might need to increase the sleep value. Try small increments.      
      # sleep 0.1
      sleep ENV['SLEEP'].to_f if ENV['SLEEP']
    end unless locs.nil?
  end
  
  if ENV['METHOD'] == 'readall'
    open(file) do |f|
      records = JSON.parse(f.read)
      records.each do |data_item|
        parse(data_item)
      end
    end
  else
    open(file).each do |line|
      data_item = JSON.parse(line)
      parse(data_item)
    end
  end
  puts "===> Done populating the DB with #{file}."
  if File.exists?('data/invalid_records.json')
    puts "===> Some locations failed to load. Check data/invalid_records.json."
  end
end

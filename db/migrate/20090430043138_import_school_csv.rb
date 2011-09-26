require "csv"

class ImportSchoolCsv < ActiveRecord::Migration
  def self.up
    path = File.join("#{Rails.root}/db/UC_live_server.csv")
    csv = CSV
    csv.foreach(path) do |row|
      arr = row[0].split(";")
      country_iso = arr[0]
      state_name = arr[1]
      city_name = arr[2]
      school_name = arr[3]
      type = arr[4]
      website = arr[5]
      
      if country_iso != "" && state_name != "" && city_name != ""
        country = Country.find_by_iso3(country_iso)
        state = State.find_by_name(state_name)
        city = City.find_or_create_by_country_id_and_state_id_and_name(country.id, state.id, city_name)
        record = School.new(
          :city_id => city.id,
          :name => school_name,
          :type_school => type,
          :website => website
        )
        record.save
      end
    end
  end
  
  def self.down
  end
end

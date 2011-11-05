require 'active_record'
require 'active_record/fixtures'
require "csv"

namespace :import do
    desc 'Import school from Csv'
    task :school => :environment do |t|
			path = File.join("#{Rails.root}/db/import_school.csv")
		  csv = CSV
		  csv.foreach(path) do |row|
		    arr = row[0].split(";")
				  country_iso = arr[0]
				  state_name = arr[1]
				  city_name = arr[2]
				  school_name = arr[3]
				  type = arr[4]
				  website = arr[5]
				  
				  if country_iso != "" && state_name != "" && city_name != "" && type != ""
				    country = Country.find_by_iso3(country_iso)
				    state = State.find_by_name(state_name)
				    city = City.find_or_create_by_country_id_and_state_id_and_name(country.id, state.id, city_name)
						School.find_or_create_by_city_id_and_type_school_and_school_name(city.id, type, school_name)
				  end
		  end
    end
end

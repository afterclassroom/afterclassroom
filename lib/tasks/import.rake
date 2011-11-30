require 'active_record'
require 'active_record/fixtures'
require "csv"

namespace :import do
    desc 'Import school from Csv'
    task :school => :environment do |t|
			path = File.join("#{Rails.root}/db/import_school.csv")
		  csv = CSV
			count = 1
		  csv.foreach(path) do |row|
				count = count + 1
		    arr = row[0].split(";")
				if arr.size > 4
				  country_iso = arr[0]
				  state_name = arr[1]
				  city_name = arr[2]
				  school_name = arr[3]
				  type = arr[4]
				  website = arr[5]
				  if country_iso != "" && state_name != "" && city_name != "" && type != ""
				    country = Country.find_by_iso3(country_iso)
				    state = State.find_or_create_by_country_id_and_name(country.id, state_name)
				    city = City.find_or_create_by_country_id_and_state_id_and_name(country.id, state.id, city_name)
						schools = School.where(:city_id => city.id, :type_school => type, :name => school_name)
						if schools.size == 0 
						  record = School.new(
						    :city_id => city.id,
						    :name => school_name,
						    :type_school => type,
						    :website => website
						  )
						  record.save!
						end
				  end
				end
		  end
    end
end

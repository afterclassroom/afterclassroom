namespace :db do
  desc 'add demo data'
  task :demo => :environment do
    require 'faker'
    #Set departments for Schools
    schools = School.find(:all)
    schools.each do |school|
      10.times do
        school.departments << Department.find(rand(Department.count) + 1)
      end
    end
    
  end
end
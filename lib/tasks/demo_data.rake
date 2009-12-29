require 'active_record'
require 'active_record/fixtures'
require 'faker'

DATA_DIRECTORY = File.join(RAILS_ROOT, "lib", "tasks", "sample_data")

namespace :db do
  namespace :demo_data do
    desc 'Load demo data'
    task :load => :environment do |t|
      departments_for_schools
      create_demo_people
      # Posts
      create_demo_posts_assignments
      create_demo_posts_tests
      create_demo_posts_projects
      create_demo_posts_exams
      create_demo_posts_myx
      create_demo_post_books
      create_demo_post_tutors
      create_demo_post_jobs
      create_demo_post_educations
      create_demo_post_housings
    end
    
    desc 'Remove demo data'
    task :remove => :environment do |t|
      Rake::Task["db:migrate:reset"].invoke
      #Remove images to avoid accumulation.
      system("rm -rf index/developments")
      system("rm -rf public/attaches")
      system("rm -rf public/avatars")
      system("rm -rf public/music_attaches")
      system("rm -rf public/photo_attaches")
      system("rm -rf public/video_attaches")
    end
    
    desc 'Reload demo data'
    task :reload => :environment do |t|
      Rake::Task["db:demo_data:remove"].invoke
      Rake::Task["db:migrate"].invoke
      Rake::Task["db:demo_data:load"].invoke
    end
  end
end

def departments_for_schools
  #Set departments for Schools
    schools = School.find(:all)
    schools.each do |school|
      5.times do
        school.departments << Department.find(rand(Department.count) + 1)
      end
    end
end

def create_demo_people
  description = "This is a description for "
  %w[male female].each do |gender|
    filename = File.join(DATA_DIRECTORY, "#{gender}_names.txt")
    names = File.open(filename).readlines[0...10]
    password = "foobar"
    avatars = Dir.glob("lib/tasks/sample_data/#{gender}_photos/*.jpg").shuffle
    names.each_with_index do |name, i|
      name.strip!
      school = School.find(rand(School.count) + 1)
      user = User.create do |u|
        u.login = name.downcase
        u.password = password
        u.email = "#{name.downcase}@example.com"
        u.name = name
        u.school = school
        u.avatar = uploaded_file(avatars[i], 'image/jpg')
        u.user_information = UserInformation.new()
        u.user_education = UserEducation.new()
        u.user_employment = UserEmployment.new()
      end
      
      user.register!
      user.activate!
    end
  end
end

def create_demo_posts_assignments
  post_category = PostCategory.find_by_name("Assignments")
  10.times do
    user = User.find(rand(User.count) + 1)
    school = School.find(rand(School.count) + 1)
    schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
    post = Post.create do |p|
      p.user = user
      p.post_category = post_category
      p.title = Faker::Lorem.sentence
      p.description = Faker::Lorem.paragraphs
      p.school = school
      p.department = school.departments.find(:first)
      p.email = Faker::Internet.email
      p.telephone = Faker::PhoneNumber.phone_number
      p.type_name = post_category.name
      p.school_year = schoolyear[rand(schoolyear.size)]
    end
    
    post_asm = PostAssignment.create do |pa|
    	pa.post = post
    	pa.due_date = DateTime.now + rand(20)
    end
    
  end
end

def create_demo_posts_tests
  post_category = PostCategory.find_by_name("Tests")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  
  20.times do
    user = User.find(rand(User.count) + 1)
    school = School.find(rand(School.count) + 1)
    post = Post.create do |p|
      p.user = user
      p.post_category = post_category
      p.title = Faker::Lorem.sentence
      p.description = Faker::Lorem.paragraphs
      p.school = school
      p.department = school.departments.find(:first)
      p.email = Faker::Internet.email
      p.telephone = Faker::PhoneNumber.phone_number
      p.type_name = post_category.name
      p.school_year = schoolyear[rand(schoolyear.size)]
    end
  end
end

def create_demo_posts_projects
  post_category = PostCategory.find_by_name("Projects")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  20.times do
    user = User.find(rand(User.count) + 1)
    school = School.find(rand(School.count) + 1)
    post = Post.create do |p|
      p.user = user
      p.post_category = post_category
      p.title = Faker::Lorem.sentence
      p.description = Faker::Lorem.paragraphs
      p.school = school
      p.department = school.departments.find(:first)
      p.email = Faker::Internet.email
      p.telephone = Faker::PhoneNumber.phone_number
      p.type_name = post_category.name
      p.school_year = schoolyear[rand(schoolyear.size)]
    end
    
    post_proj = PostProject.create do |prj|
    	prj.post = post
    	prj.due_date = DateTime.now + rand(20)
	end    
    
  end
end

def create_demo_posts_exams
  post_category = PostCategory.find_by_name("Exams")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  20.times do
    user = User.find(rand(User.count) + 1)
    school = School.find(rand(School.count) + 1)
    post = Post.create do |p|
      p.user = user
      p.post_category = post_category
      p.title = Faker::Lorem.sentence
      p.description = Faker::Lorem.paragraphs
      p.school = school
      p.department = school.departments.find(:first)
      p.email = Faker::Internet.email
      p.telephone = Faker::PhoneNumber.phone_number
      p.type_name = post_category.name
      p.school_year = schoolyear[rand(schoolyear.size)]
    end
  end
end

def create_demo_posts_myx
  post_category = PostCategory.find_by_name("MyX")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  20.times do
    user = User.find(rand(User.count) + 1)
    school = School.find(rand(School.count) + 1)
    post = Post.create do |p|
      p.user = user
      p.post_category = post_category
      p.title = Faker::Lorem.sentence
      p.description = Faker::Lorem.paragraphs
      p.school = school
      p.department = school.departments.find(:first)
      p.email = Faker::Internet.email
      p.telephone = Faker::PhoneNumber.phone_number
      p.type_name = post_category.name
      p.school_year = schoolyear[rand(schoolyear.size)]
    end
  end
end

def create_demo_post_books
  post_category = PostCategory.find_by_name("Books")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
    200.times do
      user = User.find(rand(User.count) + 1)
      school = School.find(rand(School.count) + 1)
      post = Post.create do |p|
        p.user = user
        p.post_category = post_category
        p.title = Faker::Lorem.sentence
        p.description = Faker::Lorem.paragraphs
        p.school = school
        p.department = school.departments.find(:first)
        p.email = Faker::Internet.email
        p.telephone = Faker::PhoneNumber.phone_number
        p.type_name = post_category.name
        p.school_year = schoolyear[rand(schoolyear.size)]
      end
      
      accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
      currency = ['USD', 'CAD']
      
      post_book = PostBook.create do |b|
        b.post = post 
        b.price = "500"
        b.currency = currency[rand(currency.size)]
        b.accept_payment = accept_payment[rand(accept_payment.size)]

        b.shipping_method_id = ShippingMethod.find(rand(ShippingMethod.count) + 1)

        b.in_stock = "Stock"
      end
    end
end

def create_demo_post_tutors
  post_category = PostCategory.find_by_name("Tutors")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
    200.times do
      user = User.find(rand(User.count) + 1)
      school = School.find(rand(School.count) + 1)
      post = Post.create do |p|
        p.user = user
        p.post_category = post_category
        p.title = Faker::Lorem.sentence
        p.description = Faker::Lorem.paragraphs
        p.school = school
        p.department = school.departments.find(:first)
        p.email = Faker::Internet.email
        p.telephone = Faker::PhoneNumber.phone_number
        p.type_name = post_category.name
        p.school_year = schoolyear[rand(schoolyear.size)]
      end
      
	  per = ['Hour', 'Session', 'Week', 'Month', 'Semester']
      tutoring_rate = ['Good','Bad','Average']
      currency = ['USD', 'CAD']
      
      post_tutor = PostTutor.create do |t|
        t.post = post
        t.tutoring_rate=tutoring_rate[rand(tutoring_rate.size)]
        t.per=per[rand(per.size)]
        t.currency=currency[rand(currency.size)]
        t.from=DateTime.now
        t.to=DateTime.now+3
      end
    end
end

def create_demo_post_jobs
  post_category = PostCategory.find_by_name("Jobs")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
    100.times do
      user = User.find(rand(User.count) + 1)
      school = School.find(rand(School.count) + 1)
      post = Post.create do |p|
        p.user = user
        p.post_category = post_category
        p.title = Faker::Lorem.sentence
        p.description = Faker::Lorem.paragraphs
        p.school = school
        p.department = school.departments.find(:first)
        p.email = Faker::Internet.email
        p.telephone = Faker::PhoneNumber.phone_number
        p.type_name = post_category.name
        p.school_year = schoolyear[rand(schoolyear.size)]
      end
      
      responsibilities=['role1','role2','role3']
      required_skills=['skill1','skill2','skill3']
      desirable_skills=['skillA','skillB','skillC']
      edu_experience_require=['levelA','levelB','levelC']
      compensation=['111','222','333']
      
      post_job = PostJob.create do |j|
        j.post = post
        j.responsibilities = responsibilities[rand(responsibilities.size)]
        j.required_skills = required_skills[rand(required_skills.size)]
        j.desirable_skills = desirable_skills[rand(desirable_skills.size)]
        j.edu_experience_require = edu_experience_require[rand(edu_experience_require.size)]
        j.compensation = compensation[rand(compensation.size)]
        j.prepare_post = rand(2);
      end
    end
end

def create_demo_post_educations
  post_category = PostCategory.find_by_name("Education")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
    100.times do
      user = User.find(rand(User.count) + 1)
      school = School.find(rand(School.count) + 1)
      post = Post.create do |p|
        p.user = user
        p.post_category = post_category
        p.title = Faker::Lorem.sentence
        p.description = Faker::Lorem.paragraphs
        p.school = school
        p.department = school.departments.find(:first)
        p.email = Faker::Internet.email
        p.telephone = Faker::PhoneNumber.phone_number
        p.type_name = post_category.name
        p.school_year = schoolyear[rand(schoolyear.size)]
      end
      
      education_category=EducationCategory.find(rand(EducationCategory.count) + 1)
      
      
      post_edu = PostEducation.create do |e|
        e.post = post
        e.education_category = education_category
      end
    end
end

def create_demo_post_housings
  post_category = PostCategory.find_by_name("Housing")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
    100.times do
      user = User.find(rand(User.count) + 1)
      school = School.find(rand(School.count) + 1)
      post = Post.create do |p|
        p.user = user
        p.post_category = post_category
        p.title = Faker::Lorem.sentence
        p.description = Faker::Lorem.paragraphs
        p.school = school
        p.department = school.departments.find(:first)
        p.email = Faker::Internet.email
        p.telephone = Faker::PhoneNumber.phone_number
        p.type_name = post_category.name
        p.school_year = schoolyear[rand(schoolyear.size)]
      end
      
      rent = ['rentA','rentB', 'rentC']
      currency = ['USD', 'CAD']
      intersection = ['intersectionA', 'intersectionB', 'intersectionC']
      
      
      phouse = PostHousing.create do |ph|
      	ph.post = post
      	ph.street = Faker::Address.street_name
      	ph.city = Faker::Address.city
      	ph.state = Faker::Address.us_state
      	ph.rent = rent[rand(rent.size)]
      	ph.currency = currency[rand(currency.size)]
      	ph.intersection = intersection[rand(intersection.size)]
  	  end
  	  
  	  #generate number of housingCategory that PostHousing belongs to
  	  noOfMapping = rand(HousingCategory.count) + 1
  	  pivotArray = [false,false,false,false]
  	  
  	  noOfMapping.times do
  	  	index = rand(HousingCategory.count) + 1
  	  	while (pivotArray[index]==true)
  	  		index = rand(HousingCategory.count) + 1
  	  	end
  	  	pivotArray[index] = true;
        phouse.housing_categories << HousingCategory.find(index)
      end
    end	
end

def uploaded_file(filename, content_type)
  f = File.new(File.join(RAILS_ROOT, filename))
  return f
end
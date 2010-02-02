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

      # Begin creating Posts data
      create_demo_posts_assignments
      create_demo_posts_tests
      create_demo_posts_projects
      create_demo_posts_exams
      create_demo_posts_myx
      create_demo_post_books
      create_demo_post_tutors
      create_demo_post_jobs
      create_demo_post_housings
      create_demo_post_parties
      create_demo_posts_teamups
      create_demo_posts_awarenesses
      create_demo_posts_foods
      create_demo_posts_qas

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
    school = user.school
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
      pa.professor = Faker::Name.name
      pa.due_date = DateTime.now + rand(20)
    end
    
  end
end

def create_demo_posts_tests
  post_category = PostCategory.find_by_name("Tests")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  
  20.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
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
    end#END CREATE OBJECT
    
    post_asm = PostTest.create do |pt|
      pt.post = post
      pt.due_date = DateTime.now + rand(20)
    end
    
  end
end

def create_demo_posts_projects
  post_category = PostCategory.find_by_name("Projects")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  20.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
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
    school = user.school
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
    end#END OBJECT CREATION

    post_asm = PostExam.create do |pe|
      pe.post = post
      pe.due_date = DateTime.now + rand(20)
    end

  end
end

def create_demo_posts_myx
  post_category = PostCategory.find_by_name("MyX")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  prof_status = ["Best of the best", "Good", "Bored", "Worse"]
  20.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
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
    end #END OBJECT INSTANTIATION

    post_asm = PostMyx.create do |px|
      px.post = post
      px.professor = Faker::Name.name
      #px.prof_status = prof_status[rand(prof_status.size)]
      px.good = rand(100)
      px.bored = rand(100)
      px.bad = rand(100)
      score = (px.good.to_f / (px.good.to_f + px.bored.to_f + px.bad.to_f)) * 100
      if score > 50
        px.prof_status = prof_status[1]#Good
      else
          px.prof_status = prof_status[3]#worse
      end
    end#END OBJECT CREATION
  end #END LOOP
end

def create_demo_post_books
  post_category = PostCategory.find_by_name("Books")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
    200.times do
      user = User.find(rand(User.count) + 1)
      school = user.school
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
      school = user.school
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
      school = user.school
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

def create_demo_post_housings
  post_category = PostCategory.find_by_name("Housing")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
    100.times do
      user = User.find(rand(User.count) + 1)
      school = user.school
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

def create_demo_post_parties
  post_category = PostCategory.find_by_name("Party")
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
 
  location = ['locationA','locationB', 'locationC']
  intersection = ['intersectionA', 'intersectionB', 'intersectionC']
  
    100.times do
      user = User.find(rand(User.count) + 1)
      school = user.school
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
      
      pty = PostParty.create do |pt|
      	pt.post = post
      	pt.start_time=DateTime.now
      	pt.end_time=DateTime.now+rand(3)
      	pt.location=location[rand(location.size)]
      	pt.street=Faker::Address.street_name
      	pt.intersection=intersection[rand(intersection.size)]
      	pt.city=Faker::Address.city
  	  end

  	  #generate number of partyTypes that PostParty belongs to
  	  noOfMapping = rand(PartyType.count) + 1
  	  pivotArray = [false,false,false,false,false,false,false,false,false,false]
  	  
  	  noOfMapping.times do
  	  	index = rand(PartyType.count) + 1
  	  	while (pivotArray[index]==true)
  	  		index = rand(PartyType.count) + 1
  	  	end
  	  	pivotArray[index] = true;
        pty.party_types << PartyType.find(index)
      end
      
  end #END LOOP
end #END METHOD

def create_demo_posts_teamups
  post_category = PostCategory.find_by_name("Team Up")
  opportunity = ["opportunity 1","opportunity 2","opportunity 3"]
  position = ["position 1","position 2","position 3"]
  expectedTime = ["expectedTime 1","expectedTime 2","expectedTime 3"]
  compensation = ["compensation A","compensation B","compensation C"]
  100.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
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
    
    pteam = PostTeamup.create do |pt|
    	pt.post = post
    	pt.teamup_category_id = TeamupCategory.find(rand(TeamupCategory.count)+1)
    	pt.opportunity_type = opportunity[rand(opportunity.size)]
    	pt.position_title = position[rand(position.size)]
    	pt.expected_time_commit = expectedTime[rand(expectedTime.size)]
    	pt.functional_experience_id = rand(10)+1
    	pt.compensation_offered = compensation[rand(compensation.size)]
    end
    
  end
end

def create_demo_posts_awarenesses
  post_category = PostCategory.find_by_name("Student Awareness")
  100.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
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
    
    pivotArray = [false,false,false]
    noOfMapping = rand(AwarenessIssue.count) + 1
    
    post_aq = PostAwareness.create do |pa|
    	pa.post = post
    	pa.campaign_start = DateTime.now + rand(20)
    	pa.campaign_end = DateTime.now + rand(20)+3
    end
    
    noOfMapping.times do
  	  	index = rand(AwarenessIssue.count) + 1
  	  	while (pivotArray[index]==true)
  	  		index = rand(AwarenessIssue.count) + 1
  	  	end
  	  	pivotArray[index] = true;
        post_aq.awareness_issues << AwarenessIssue.find(index)
  	end#END MAPPING
  end#END LOOP
end

def create_demo_posts_foods
  post_category = PostCategory.find_by_name("Foods")
  100.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
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
    
    pf = PostFood.create do |p|
    	p.post = post
    	p.street = Faker::Address.street_name
    	p.city = Faker::Address.city
    	p.state = Faker::Address.us_state
    	p.phone = Faker::PhoneNumber.phone_number
    end
    
  end
end

def create_demo_posts_qas
  post_category = PostCategory.find_by_name("QAs")
  
  10.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
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
    
    qaCat = PostQaCategory.find(rand(PostQaCategory.count) + 1)
    
    post_qa = PostQa.create do |p|
      p.post = post
      p.post_qa_category = qaCat
    end
    
  end
end
def uploaded_file(filename, content_type)
  f = File.new(File.join(RAILS_ROOT, filename))
  return f
end
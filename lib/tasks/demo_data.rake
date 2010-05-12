require 'active_record'
require 'active_record/fixtures'
require 'faker'

DATA_DIRECTORY = File.join(RAILS_ROOT, "lib", "tasks", "sample_data")

namespace :db do
  namespace :demo_data do
    desc 'Load demo data'
    task :load => :environment do |t|
      # Users
      #      departments_for_schools
      #      create_demo_people
#      create_demo_friendship

      # Begin creating Posts data
      #      create_demo_posts_assignments
      #      create_demo_posts_tests
      #      create_demo_posts_projects
      #      create_demo_posts_exams
      #      create_demo_posts_myx
      #      create_demo_posts_books
      #      create_demo_posts_tutors
      #      create_demo_posts_jobs
      #      create_demo_posts_housings
      #      create_demo_posts_parties
      #      create_demo_posts_teamups
      #      create_demo_posts_awarenesses
      #      create_demo_posts_foods
      #      create_demo_posts_qas

      # Exam schedule
      #      create_demo_posts_exam_schedules

      # Messages data
      #      create_demo_messages

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

def create_demo_friendship
  users = User.find(:all)
  friends = User.find(:all)
  users.each do |u|
    friends.each do |f|
      unless u == f
        invite = UserInvite.create(:user => u, :user_target => f, :message => "let's be friends!")
        invite.is_accepted = true
        invite.save and u.reload and f.reload
      end
    end
  end
end

def create_demo_posts_assignments
  type_name = "PostAssignment"
  post_category = PostCategory.find_by_class_name(type_name)
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
   
    post = create_post(user, school, post_category)
    
    post_asm = PostAssignment.create do |pa|
      pa.post = post
      pa.department = school.departments.find(:first)
      pa.school_year = schoolyear[rand(schoolyear.size)]
      pa.professor = Faker::Name.name
      pa.due_date = DateTime.now + rand(20)
      pa.tag_list = get_random_list_tags
    end
    
  end
end

def create_demo_posts_tests
  type_name = "PostTest"
  post_category = PostCategory.find_by_class_name(type_name)
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_t = PostTest.create do |pt|
      pt.post = post
      pt.department = school.departments.find(:first)
      pt.school_year = schoolyear[rand(schoolyear.size)]
      pt.due_date = DateTime.now + rand(20)
      pt.tag_list = get_random_list_tags
    end
    
  end
end

def create_demo_posts_projects
  type_name = "PostProject"
  post_category = PostCategory.find_by_class_name(type_name)
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_proj = PostProject.create do |prj|
    	prj.post = post
      prj.department = school.departments.find(:first)
      prj.school_year = schoolyear[rand(schoolyear.size)]
    	prj.due_date = DateTime.now + rand(20)
      prj.tag_list = get_random_list_tags
    end
    
  end
end

def create_demo_posts_exams
  type_name = "PostExam"
  post_category = PostCategory.find_by_class_name(type_name)
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]

  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_asm = PostExam.create do |pe|
      pe.post = post
      pe.department = school.departments.find(:first)
      pe.school_year = schoolyear[rand(schoolyear.size)]
      pe.due_date = DateTime.now + rand(20)
      pe.tag_list = get_random_list_tags
    end

  end
end

def create_demo_posts_myx
  type_name = "PostMyx"
  post_category = PostCategory.find_by_class_name(type_name)
  prof_status = ["Best of the best", "Good", "Bored", "Worse"]

  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_asm = PostMyx.create do |px|
      px.post = post
      px.professor = Faker::Name.name
      px.tag_list = get_random_list_tags
    end
  end
end

def create_demo_posts_books
  type_name = "PostBook"
  post_category = PostCategory.find_by_class_name(type_name)
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_book = PostBook.create do |b|
      b.post = post
      b.book_type = BookType.find(rand(BookType.count) + 1)
      b.department = school.departments.find(:first)
      b.school_year = schoolyear[rand(schoolyear.size)]
      b.address = Faker::Address.street_address
      b.phone = Faker::PhoneNumber.phone_number
      b.price = "500"
      b.tag_list = get_random_list_tags
    end
  end
end

def create_demo_posts_tutors
  type_name = "PostTutor"
  post_category = PostCategory.find_by_class_name(type_name)
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]

  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
      
    post_tutor = PostTutor.create do |t|
      t.post = post
      t.tutor_type = TutorType.find(rand(TutorType.count) + 1)
      t.department = school.departments.find(:first)
      t.school_year = schoolyear[rand(schoolyear.size)]
      t.address = Faker::Address.street_address
      t.phone = Faker::PhoneNumber.phone_number
      t.tag_list = get_random_list_tags
    end
  end
end

def create_demo_posts_jobs
  type_name = "PostJob"
  post_category = PostCategory.find_by_class_name(type_name)
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  responsibilities=['role1','role2','role3']
  required_skills=['skill1','skill2','skill3']
  desirable_skills=['skillA','skillB','skillC']
  edu_experience_require=['levelA','levelB','levelC']
  compensation=['111','222','333']
    
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
      
    post_job = PostJob.create do |j|
      j.post = post
      j.job_type = JobType.find(rand(JobType.count) + 1)
      j.department = school.departments.find(:first)
      j.school_year = schoolyear[rand(schoolyear.size)]
      j.address=Faker::Address.street_address
      j.phone = Faker::PhoneNumber.phone_number
      j.responsibilities = responsibilities[rand(responsibilities.size)]
      j.required_skills = required_skills[rand(required_skills.size)]
      j.desirable_skills = desirable_skills[rand(desirable_skills.size)]
      j.edu_experience_require = edu_experience_require[rand(edu_experience_require.size)]
      j.compensation = compensation[rand(compensation.size)]
      j.prepare_post = rand(2);
      j.tag_list = get_random_list_tags
    end
  end
end

def create_demo_posts_housings
  type_name = "PostHousing"
  post_category = PostCategory.find_by_class_name(type_name)
  rent = ['rentA','rentB', 'rentC']
  currency = ['USD', 'CAD']

  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)  
      
    phouse = PostHousing.create do |ph|
      ph.post = post
      ph.address = Faker::Address.street_address
      ph.rent = rent[rand(rent.size)]
      ph.currency = currency[rand(currency.size)]
      ph.tag_list = get_random_list_tags
    end
  	  
    #generate number of housingCategory that PostHousing belongs to
    noOfMapping = rand(HousingCategory.count) + 1
    pivotArray = [false,false,false,false]
  	  
    noOfMapping.times do
      index = rand(HousingCategory.count) + 1
      while (pivotArray[index] == true)
        index = rand(HousingCategory.count) + 1
      end
      pivotArray[index] = true;
      phouse.housing_categories << HousingCategory.find(index)
    end
  end
end

def create_demo_posts_parties
  type_name = "PostParty"
  post_category = PostCategory.find_by_class_name(type_name)
  
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
      
    pty = PostParty.create do |pt|
      pt.post = post
      pt.start_time = DateTime.now
      pt.end_time = DateTime.now + rand(3)
      pt.address = Faker::Address.street_address
      pt.tag_list = get_random_list_tags
    end

    #generate number of partyTypes that PostParty belongs to
    noOfMapping = rand(PartyType.count) + 1
    pivotArray = [false,false,false,false,false,false,false,false,false,false]
  	  
    noOfMapping.times do
      index = rand(PartyType.count) + 1
      while (pivotArray[index] == true)
        index = rand(PartyType.count) + 1
      end
      pivotArray[index] = true;
      pty.party_types << PartyType.find(index)
    end
      
  end #END LOOP
end #END METHOD

def create_demo_posts_teamups
  type_name = "PostTeamup"
  post_category = PostCategory.find_by_class_name(type_name)
  
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    pteam = PostTeamup.create do |pt|
    	pt.post = post
    	pt.teamup_category_id = TeamupCategory.find(rand(TeamupCategory.count)+1)
      pt.ourStatus = Faker::Lorem.sentence
      pt.founded_in = DateTime.now - rand(30)
      pt.noOfMember = rand(200)
      pt.tag_list = get_random_list_tags
    end
    
  end
end

def create_demo_posts_awarenesses
  type_name = "PostAwareness"
  post_category = PostCategory.find_by_class_name(type_name)
  
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
    
    post = create_post(user, school, post_category)
    
    post_a = PostAwareness.create do |pa|
      type = AwarenessType.find(rand(AwarenessType.count) + 1)
    	pa.post = post
      pa.awareness_type = type
    	pa.due_date = DateTime.now + rand(20) if type.label == "take_action_now"
    	pa.phone = Faker::PhoneNumber.phone_number if type.label == "emergency_alerts"
      pa.tag_list = get_random_list_tags
    end
  end
end

def create_demo_posts_foods
  post_category = PostCategory.find_by_name("Foods")

  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
    
    post = create_post(user, school, post_category)
    
    pf = PostFood.create do |p|
    	p.post = post
    	p.address = Faker::Address.street_address
    	p.phone = Faker::PhoneNumber.phone_number
      p.tag_list = get_random_list_tags
    end
    
  end
end

def create_demo_posts_qas
  post_category = PostCategory.find_by_name("QAs")
  
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school
    
    post = create_post(user, school, post_category)
    
    qaCat = PostQaCategory.find(rand(PostQaCategory.count) + 1)
    
    post_qa = PostQa.create do |p|
      p.post = post
      p.post_qa_category = qaCat
      p.tag_list = get_random_list_tags
    end
    
  end
end

def create_demo_posts_exam_schedules
  200.times do
    user = User.find(rand(User.count) + 1)
    school = user.school

    es = PostExamSchedule.create do |p|
    	p.user = user
      p.school = school
      p.subject = Faker::Lorem.sentence
    	p.teacher_name = Faker::Name.name
    	p.place = Faker::Address.street_address
      p.starts_at = DateTime.now + rand(20)
      p.type_name = SCHEDULE_TYPE[rand(SCHEDULE_TYPE.size)].first
    end

  end
end

def create_demo_messages
  200.times do
    user = User.find(rand(User.count) + 1)

    User.find(:all).each do |u|
      unless user == u
        ms = Message.create do |m|
          m.sender_id = user.id
          m.recipient_id = u.id
          m.subject = Faker::Lorem.sentence
          m.body = Faker::Lorem.paragraphs
        end
      end
    end
  end
end

def create_post(user, school, post_category)
  post = Post.create do |p|
    p.user = user
    p.post_category = post_category
    p.title = Faker::Lorem.sentence
    p.description = Faker::Lorem.paragraphs
    p.school = school
    p.type_name = post_category.class_name
  end
end

def uploaded_file(filename, content_type)
  f = File.new(File.join(RAILS_ROOT, filename))
  return f
end

def get_random_list_tags
  arr_list_tag = [
    "tag 1, tag 2, tag 3, tag 4",
    "tag 11, tag 12, tag 13, tag 14",
    "tag 21, tag 22, tag 23, tag 24",
    "tag 31, tag 32, tag 33, tag 34",
    "tag 41, tag 42, tag 43, tag 44",
    "tag 51, tag 52, tag 53, tag 54"
  ]
  arr_list_tag[rand(arr_list_tag.size)]
end
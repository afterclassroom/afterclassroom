require 'active_record'
require 'active_record/fixtures'
require 'faker'

DATA_DIRECTORY = File.join(Rails.root, "lib", "tasks", "sample_data")

namespace :db do
  namespace :demo_data do
    desc 'Load demo data'
    task :load => :environment do |t|
      # Users
      departments_for_schools
      create_demo_people
      create_demo_friendship
      create_demo_fan
      create_demo_wall
      # Begin creating Posts data
      create_demo_posts_assignments
      create_demo_posts_tests
      create_demo_posts_projects
      create_demo_posts_exams
      create_demo_posts_myx
      create_demo_posts_books
      create_demo_posts_tutors
      create_demo_posts_jobs
      create_demo_posts_housings
      create_demo_posts_parties
      create_demo_posts_teamups
      create_demo_posts_awarenesses
      create_demo_posts_foods
      create_demo_posts_qas
      create_demo_posts_events

      # Exam schedule
      create_demo_posts_exam_schedules
      # Messages data
      create_demo_messages
      # Story
      create_demo_stories

    end
    
    desc 'Remove demo data'
    task :remove => :environment do |t|
      Rake::Task["db:migrate:reset"].invoke
      #Remove images to avoid accumulation.
      system("rm -rf index/developments")
      system("rm -rf public/attaches")
      system("rm -rf public/avatars")
      system("rm -rf public/music_album_attaches")
      system("rm -rf public/music_attaches")
      system("rm -rf public/photos")
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
  schools = School.all
  schools.each do |school|
    school.departments << Department.all
  end
end

def create_demo_people
  sex = {"male" => true, "female" => false}
  relationship_status = ["Single", "Married"]
  %w[male female].each do |gender|
    filename = File.join(DATA_DIRECTORY, "#{gender}_names.txt")
    names = File.open(filename).readlines
    password = "foobar"
    avatars = Dir.glob("lib/tasks/sample_data/#{gender}_photos/*.jpg").shuffle
    names.each_with_index do |name, i|
      
      name.strip!
      school = School.find(rand(School.count).to_i + 1)

      user_infor = UserInformation.new do |f|
        f.sex = sex[gender.to_s]
        f.relationship_status = relationship_status[rand(relationship_status.size).to_i]
        f.looking_for = Faker::Lorem.paragraphs
        f.polictical_view = Faker::Lorem.paragraphs
        f.mobile_number = Faker::PhoneNumber.phone_number
        f.current_city = Faker::Address.street_address
        f.website = Faker::Internet.domain_name
      end

      user_edu = UserEducation.new do |f|
        f.grad_school = Faker::Lorem.sentence
        f.college = Faker::Lorem.sentence
        f.high_school = Faker::Lorem.sentence
      end

      user_employ = UserEmployment.new do |f|
        f.current_employer = Faker::Lorem.sentence
        f.position_current = Faker::Lorem.sentence
        f.time_period = Faker::Lorem.sentence
        f.location = Faker::Address.street_address
      end
      
      user = User.create do |u|
        u.login = name.downcase
        u.password = u.password_confirmation = password
        u.email = "#{name.downcase}@example.com"
        u.name = name
        u.school = school
        u.avatar = uploaded_file(avatars[i])
      end

      user.user_information = user_infor
      user.user_education = user_edu
      user.user_employment = user_employ

      user.save!
      
      user.register!
      user.activate!
    end
  end
end

def create_demo_friendship
  users = User.all
  friends = User.all
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

def create_demo_fan
  users = User.all
  fans = User.all
  users.each do |u|
    fans.each do |f|
      unless u == f
        fan = Fan.new
        fan.user_id = f.id
        u.fans << fan
      end
    end
  end
end

def create_demo_wall
  users = User.all
  users.each do |u|
    friends = u.user_friends
    friends.each do |f|
      UserWall.create do |w|
        w.user_id = u.id
        w.user_id_post = f.id
        w.content = Faker::Lorem.paragraphs
      end
    end
  end
end

def create_demo_posts_assignments
  type_name = "PostAssignment"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school
   
    post = create_post(user, school, post_category)
    
    post_assignment = PostAssignment.create do |pa|
      pa.post = post
      pa.professor = Faker::Name.name
      pa.due_date = DateTime.now + rand(20).to_i
    end
    
    post.school.tag(post_assignment, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_tests
  type_name = "PostTest"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_test = PostTest.create do |pt|
      pt.post = post
      pt.due_date = DateTime.now + rand(20).to_i
    end
    
    post.school.tag(post_test, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_projects
  type_name = "PostProject"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_project = PostProject.create do |prj|
      prj.post = post
      prj.due_date = DateTime.now + rand(20).to_i
    end
    
    post.school.tag(post_project, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_exams
  type_name = "PostExam"
  post_category = PostCategory.find_by_class_name(type_name)

  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_exam = PostExam.create do |pe|
      pe.post = post
      pe.due_date = DateTime.now + rand(20).to_i
    end
    
    post.school.tag(post_exam, :with => get_random_list_tags, :on => :tags)

  end
end

def create_demo_posts_myx
  type_name = "PostMyx"
  post_category = PostCategory.find_by_class_name(type_name)

  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_myx = PostMyx.create do |px|
      px.post = post
      px.professor = Faker::Name.name
    end
    
    post.school.tag(post_myx, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_books
  type_name = "PostBook"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_book = PostBook.create do |b|
      b.post = post
      b.book_type = BookType.find(rand(BookType.count).to_i + 1)
      b.address = Faker::Address.street_address
      b.phone = Faker::PhoneNumber.phone_number
      b.price = "500"
    end
    
    post.school.tag(post_book, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_tutors
  type_name = "PostTutor"
  post_category = PostCategory.find_by_class_name(type_name)

  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
      
    post_tutor = PostTutor.create do |t|
      t.post = post
      t.tutor_type = TutorType.find(rand(TutorType.count).to_i + 1)
      t.address = Faker::Address.street_address
      t.phone = Faker::PhoneNumber.phone_number
    end
    
    post.school.tag(post_tutor, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_jobs
  type_name = "PostJob"
  post_category = PostCategory.find_by_class_name(type_name)
  responsibilities=['role1','role2','role3']
  required_skills=['skill1','skill2','skill3']
  desirable_skills=['skillA','skillB','skillC']
  edu_experience_require=['levelA','levelB','levelC']
  compensation=['111','222','333']
    
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
      
    post_job = PostJob.create do |j|
      j.post = post
      j.job_type = JobType.find(rand(JobType.count).to_i + 1)
      j.address=Faker::Address.street_address
      j.phone = Faker::PhoneNumber.phone_number
      j.responsibilities = responsibilities[rand(responsibilities.size).to_i]
      j.required_skills = required_skills[rand(required_skills.size).to_i]
      j.desirable_skills = desirable_skills[rand(desirable_skills.size).to_i]
      j.edu_experience_require = edu_experience_require[rand(edu_experience_require.size).to_i]
      j.compensation = compensation[rand(compensation.size).to_i]
      j.prepare_post = rand(2).to_i;
    end
    
    post.school.tag(post_job, :with => get_random_list_tags, :on => :tags)
    
  end

  # Create job information
  20.times do
    JobInfor.create do |j|
      j.title = Faker::Lorem.sentence
      j.description = Faker::Lorem.paragraphs
    end
  end
end

def create_demo_posts_housings
  type_name = "PostHousing"
  post_category = PostCategory.find_by_class_name(type_name)
  rent = ['rentA','rentB', 'rentC']
  currency = ['USD', 'CAD']

  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)  
      
    post_housing = PostHousing.create do |ph|
      ph.post = post
      ph.address = Faker::Address.street_address
      ph.rent = rent[rand(rent.size).to_i]
      ph.currency = currency[rand(currency.size).to_i]
    end
    
    post.school.tag(post_housing, :with => get_random_list_tags, :on => :tags)
  	  
    #generate number of housingCategory that PostHousing belongs to
    noOfMapping = rand(HousingCategory.count).to_i + 1
    pivotArray = [false,false,false,false]
  	  
    noOfMapping.times do
      index = rand(HousingCategory.count).to_i + 1
      while (pivotArray[index] == true)
        index = rand(HousingCategory.count).to_i + 1
      end
      pivotArray[index] = true;
      post_housing.housing_categories << HousingCategory.find(index)
    end
  end
end

def create_demo_posts_parties
  type_name = "PostParty"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
      
    post_party = PostParty.create do |pt|
      pt.post = post
      pt.start_time = DateTime.now
      pt.end_time = DateTime.now + rand(3).to_i
      pt.address = Faker::Address.street_address
    end
    
    post.school.tag(post_party, :with => get_random_list_tags, :on => :tags)

    #generate number of partyTypes that PostParty belongs to
    noOfMapping = rand(PartyType.count).to_i + 1
    pivotArray = [false,false,false,false,false,false,false,false,false,false]
  	  
    noOfMapping.times do
      index = rand(PartyType.count).to_i + 1
      while (pivotArray[index] == true)
        index = rand(PartyType.count).to_i + 1
      end
      pivotArray[index] = true;
      post_party.party_types << PartyType.find(index)
    end
      
  end #END LOOP
end #END METHOD

def create_demo_posts_teamups
  type_name = "PostTeamup"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_teamup = PostTeamup.create do |pt|
      pt.post = post
      pt.teamup_category_id = TeamupCategory.find(rand(TeamupCategory.count)+1)
    end
    
    post.school.tag(post_teamup, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_awarenesses
  type_name = "PostAwareness"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school
    
    post = create_post(user, school, post_category)
    
    post_awareness = PostAwareness.create do |pa|
      type = AwarenessType.find(rand(AwarenessType.count).to_i + 1)
      pa.post = post
      pa.awareness_type = type
      pa.due_date = DateTime.now + rand(20).to_i if type.label == "take_action_now"
      pa.phone = Faker::PhoneNumber.phone_number if type.label == "emergency_alerts"
    end
    
    post.school.tag(post_awareness, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_foods
  type_name = "PostFood"
  post_category = PostCategory.find_by_class_name(type_name)

  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school
    
    post = create_post(user, school, post_category)
    
    post_food = PostFood.create do |p|
      p.post = post
      p.address = Faker::Address.street_address
      p.phone = Faker::PhoneNumber.phone_number
    end
    
    post.school.tag(post_food, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_qas
  type_name = "PostQa"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school
    
    post = create_post(user, school, post_category)
    
    post_qa = PostQa.create do |p|
      p.post = post
    end
    
    post.school.tag(post_qa, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_events
  type_name = "PostEvent"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school
    
    post = create_post(user, school, post_category)
    
    post_event = PostEvent.create do |pe|
      type = EventType.find(rand(EventType.count).to_i + 1)
      pe.post = post
      pe.event_type = type
      pe.address = Faker::Address.street_address
      pe.phone = Faker::PhoneNumber.phone_number
    end
    
    post.school.tag(post_event, :with => get_random_list_tags, :on => :tags)
    
  end
end

def create_demo_posts_exam_schedules
  type_name = "PostExamSchedule"
  post_category = PostCategory.find_by_class_name(type_name)
  
  20.times do
    user = User.find(rand(User.count).to_i + 1)
    school = user.school

    post = create_post(user, school, post_category)
    
    post_examschedule = PostExamSchedule.create do |p|
      p.post = post
      p.teacher_name = Faker::Name.name
      p.place = Faker::Address.street_address
      p.starts_at = DateTime.now + rand(10).to_i
      p.starts_at = DateTime.now + rand(20).to_i
      p.type_name = SCHEDULE_TYPE[rand(SCHEDULE_TYPE.size).to_i][1]
    end
    
    post.school.tag(post_examschedule, :with => get_random_list_tags, :on => :tags)

  end
end

def create_demo_messages
  20.times do
    user = User.find(rand(User.count).to_i + 1)

    User.all.each do |u|
      unless user == u
        Message.create do |m|
          m.sender_id = user.id
          m.recipient_id = u.id
          m.subject = Faker::Lorem.sentence
          m.body = Faker::Lorem.paragraphs
        end
      end
    end
  end
end

def create_demo_stories
  User.all.each do |u|
    20.times do
      Story.create do |s|
        s.user_id = u.id
        s.title = Faker::Lorem.sentence
        s.content = Faker::Lorem.paragraphs
      end
    end
  end
end

def create_post(user, school, post_category)
  schoolyear = ["1year", "2year", "3year", "4year", "ms.c", "ph.d"]
  Post.create do |p|
    p.user = user
    p.department = school.departments.find(:first)
    p.school_year = schoolyear[rand(schoolyear.size).to_i]
    p.post_category = post_category
    p.type_name = post_category.class_name
    p.title = Faker::Lorem.sentence
    p.description = Faker::Lorem.paragraphs
    p.school = school
  end
end

def uploaded_file(filename)
  f = File.new(File.join(Rails.root, filename))
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
  arr_list_tag[rand(arr_list_tag.size).to_i]
end
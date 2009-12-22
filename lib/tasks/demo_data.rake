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
      create_demo_posts_assignments
      create_demo_posts_tests
      create_demo_posts_projects
      create_demo_posts_exams
      create_demo_posts_myx
      create_demo_post_books
    end
    
    desc 'Remove demo data'
    task :remove => :environment do |t|
      Rake::Task["db:migrate:reset"].invoke
      #Remove images to avoid accumulation.
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
    end
  end
end

def create_demo_posts_tests
  post_category = PostCategory.find_by_name("Tests")
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
    end
  end
end

def create_demo_posts_projects
  post_category = PostCategory.find_by_name("Projects")
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
    end
  end
end

def create_demo_posts_exams
  post_category = PostCategory.find_by_name("Exams")
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
    end
  end
end

def create_demo_posts_myx
  post_category = PostCategory.find_by_name("MyX")
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
    end
  end
end

def create_demo_post_books
  post_category = PostCategory.find_by_name("Books")
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
      end
      
      accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
      currency = ['USD', 'CAD']
      
      post_book = PostBook.create do |b|
        b.post = post
        b.price = "500"
        b.currency = currency[rand(currency.size) + 1]
        b.accept_payment = accept_payment[rand(accept_payment.size)]
        b.shipping_method_id = ShippingMethod.find(rand(ShippingMethod.count))
        b.in_stock = "Stock"
      end
    end
end

def uploaded_file(filename, content_type)
  f = File.new(File.join(RAILS_ROOT, filename))
  return f
end
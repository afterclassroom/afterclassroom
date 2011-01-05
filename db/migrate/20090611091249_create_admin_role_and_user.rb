class CreateAdminRoleAndUser < ActiveRecord::Migration
  def self.up
    # Create admin role and user
    admin_role = Role.create(:name => 'admin')

    user = User.create do |u|
      u.login = 'administrator'
      u.password = u.password_confirmation = 'foobar'
      u.email = 'admin@afterclassroom.com'
      u.user_information = UserInformation.new()
      u.user_education = UserEducation.new()
      u.user_employment = UserEmployment.new()
      u.school = School.find(:first)
    end

    user.register
    user.activate

    user.roles << admin_role
    
    user.save
  end

  def self.down
  end
end
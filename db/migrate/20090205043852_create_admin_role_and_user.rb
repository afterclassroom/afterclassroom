class CreateAdminRoleAndUser < ActiveRecord::Migration
  def self.up
    # Create admin role and user
    admin_role = Role.create(:name => 'admin')

    user = User.create do |u|
      u.login = 'admin'
      u.password = u.password_confirmation = 'admin'
      u.email = 'admin@afterclassroom.com'
      u.user_information = UserInformation.new()
      u.user_education = UserEducation.new()
      u.user_employment = UserEmployment.new()
    end

    user.register!
    user.activate!

    user.roles << admin_role
  end

  def self.down
  end
end
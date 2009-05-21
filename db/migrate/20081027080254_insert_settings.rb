class InsertSettings < ActiveRecord::Migration
  def self.up
    Setting.create(:label => "Site name", :identifier => 'site_name', :value => 'AfterClassroom')
    Setting.create(:label => "Site url", :identifier => 'site_url', :value => 'http://afterclassroom.com')
    Setting.create(:label => "Company name", :identifier => 'company_name', :value => 'AfterClassroom')
    Setting.create(:label => "Admin email", :identifier => 'admin_email', :value => 'admin@afterclassroom.com')
    Setting.create(:label => "Support name", :identifier => 'support_name', :value => 'Support')
    Setting.create(:label => "Support email", :identifier => 'support_email', :value => 'support@afterclassroom.com')
  end

  def self.down
  end
end

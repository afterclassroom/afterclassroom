ActiveAdmin.register ReportAbuse do
  menu :parent => "Report Abuse"
  filter :report_abuse_category
  filter :reported_type
  filter :created_at
  filter :updated_at
  
  index do
    column "User" do |post|
      User.find(post.reporter_id).name
    end
    column :reported_type
		column :created_at
		column :updated_at
    default_actions
  end
end

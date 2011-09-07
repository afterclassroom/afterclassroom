ActiveAdmin.register ReportAbuse do
  menu :parent => "Report Abuse"
<<<<<<< HEAD
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
=======
	
>>>>>>> 56206aa51e5ad14bba6943c4a1088f8e0926156a
end

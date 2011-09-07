ActiveAdmin.register ReportAbuse do
  menu :parent => "Report Abuse"
<<<<<<< HEAD

=======
>>>>>>> 23273487277abe20958be8bcdc9d4c1c4950e2ed
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
<<<<<<< HEAD

=======
>>>>>>> 23273487277abe20958be8bcdc9d4c1c4950e2ed
end

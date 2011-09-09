ActiveAdmin.register PostAssignment do
  menu :parent => "Posts"
	filter :post_assignment_post_title_contains
	index do
		column "Title" do |post|
			post.post.title
		end
		column "Description" do |post|
			truncate(post.post.description)
		end
		column :professor
		column :due_date 
		default_actions
	end
end

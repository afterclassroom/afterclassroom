ActiveAdmin.register Comment, :as => "PostComment" do
  filter :user
  filter :comment
  filter :created_at
  filter :commentable_type
  index do
    column "User" do |post|
      post.user.name
    end
    column :comment
		column :created_at
		column :commentable_type
    default_actions
  end
end

ActiveAdmin.register Comment, :as => "PostComment" do
  filter :user
  filter :comment
  filter :created_at
  filter :commentable_type
  index do
    column :comment
		column :created_at
		column :commentable_type
  end
end

ActiveAdmin.register User do
  filter :school_id
  filter :name
  filter :email
  filter :state
  filter :created_at
  filter :online
  
  index do
    column :name
		column :email
		column :state
    column :created_at
		column :school_id
		column :online
    default_actions
  end
  
  form do |f|
      f.inputs  do
        f.input :school_id
 #       f.input :published_at, :label => "Publish Post At"
 #       f.input :category
  #    end
 #     f.inputs "Content" do
 #       f.input :body
      end
 #     f.buttons
    end
end

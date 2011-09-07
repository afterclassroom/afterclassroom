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
      f.input :school_id, :as => :select, :collection => School.all       
      f.input :login
      f.input :name
      f.input :email
      f.input :crypted_password
      f.input :state
      f.input :time_zone
    end

    f.buttons :commit
  end
end

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
  end
end

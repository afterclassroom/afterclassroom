ActiveAdmin.register AdminUser do
	filter :email
  index do
    column :email
		column :sign_in_count
		column :current_sign_in_at
		column :last_sign_in_at
		column :current_sign_in_ip
		column :last_sign_in_ip
		default_actions
  end
	form do |f|
    f.inputs "Admin Details" do
      f.input :email
    end
    f.buttons
  end
end

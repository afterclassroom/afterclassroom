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
		f.inputs "Details" do
			f.input :email
			f.input :encrypted_password
			f.buttons
		end
	end	
end

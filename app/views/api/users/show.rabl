object @user

attributes :id, :name, :email, :created_at

code :avatar do 
	@user.avatar.url(:thumb)
end

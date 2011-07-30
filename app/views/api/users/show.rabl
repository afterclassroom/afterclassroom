object @user
attributes :id, :name, :created_at
code :avatar do 
	@user.avatar.url(:thumb)
end
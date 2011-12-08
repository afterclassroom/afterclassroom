object @user

attributes :id, :name, :email, :created_at

code(:avatar) { |user| user.avatar.url(:thumb) }

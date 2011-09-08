ActiveAdmin.register School do
  menu :parent => "Schools"
	index do
		column "City" do |post|
			"#{post.city.country.name}, #{post.city.state.name}, #{post.city.name}"
		end
		column :name
		column :type_school
		default_actions
	end
end

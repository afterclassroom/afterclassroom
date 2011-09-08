ActiveAdmin.register State do
  menu :parent => "Schools", :priority => 2
	index do
		column :country
		column :name
		column :alias
		default_actions
	end
end

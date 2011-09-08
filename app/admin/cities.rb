ActiveAdmin.register City do
  menu :parent => "Schools", :priority => 3
	index do
		column :country
		column :state
		column :name
		default_actions
	end
end

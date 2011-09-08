ActiveAdmin.register Department do
  menu :parent => "Departments"
	index do
		column :department_category
		column :name
		default_actions
	end
end

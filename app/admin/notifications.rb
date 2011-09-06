ActiveAdmin.register Notification do
  menu :parent => "Notifications"
  filter :name
  filter :notify_type, :as => :select, :collection => ["AfterClassroom", "Share a Story", "Photos", "Music", "My Lounge Comments"]
	index do
    column :name
		column :label
		column :notify_type
  end
	form do |f|
      f.inputs "Details" do
        f.input :name
        f.input :label
        f.input :notify_type, :as => :select, :collection => ["AfterClassroom", "Share a Story", "Photos", "Music", "My Lounge Comments"]
      end
      f.buttons
   end
end

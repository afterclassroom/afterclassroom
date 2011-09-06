ActiveAdmin.register Notification do
  menu :parent => "Notifications"
  filter :name
  filter :notify_type, :as => :select, :collection => proc { [
                ["AfterClassroom", "AfterClassroom"],
								["Share a Story", "Share a Story"],
                ["Photos", "Photos"],
                ["Music", "Music"],
                ["My Lounge Comments","My Lounge Comments"]
              ] }
	index do
    column :name
		column :label
		column :notify_type
  end
	form do |f|
      f.inputs "Details" do
        f.input :name
        f.input :label
        f.input :notify_type, :as => :select, :collection => proc { [
								["AfterClassroom", "AfterClassroom"],
								["Share a Story", "Share a Story"],
                ["Photos", "Photos"],
                ["Music", "Music"],
                ["My Lounge Comments","My Lounge Comments"]
              ] }
      end
      f.inputs "Content" do
        f.input :body
      end
      f.buttons
   end
end

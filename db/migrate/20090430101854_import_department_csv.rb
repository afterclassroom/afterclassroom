require "csv"

class ImportDepartmentCsv < ActiveRecord::Migration
  def self.up
    category_temp = nil
    path = File.join("#{Rails.root}/db/Deapartment_categories.csv")
    csv = CSV
    csv.foreach(path) do |row|
      arr = row[0].split(";")
      category_name = arr[0]
      department_name = arr[1]
      if department_name != ""
        if category_name != ""
          category = DepartmentCategory.create(:name => category_name)
          category_temp = category
        end
        if category_temp
          record = Department.new(
            :department_category_id => category_temp.id,
            :name => department_name
          )
          record.save
        end
      end
    end
  end
  
  def self.down
  end
end

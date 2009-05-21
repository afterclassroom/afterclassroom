class AddColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :school_id, :integer
    add_column :users, :allow_search_by_email, :boolean
  end

  def self.down
  end
end

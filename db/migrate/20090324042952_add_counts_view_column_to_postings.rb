class AddCountsViewColumnToPostings < ActiveRecord::Migration
  def self.up
    add_column :posts, :count_view, :integer, :default => 0
  end

  def self.down
    remove_column :posts, :count_view
  end
end

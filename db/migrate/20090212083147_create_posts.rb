class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :post_category
      t.belongs_to :school, :null => false
      t.belongs_to :department
      t.string :school_year
      t.string :title, :null => false
      t.text :description, :null => false
      t.boolean :use_this_email, :default => 0
      t.string :type_name
			t.string :slug

      t.timestamps
    end
  end

  def self.down
    # Remove the columns we added
    Post.remove_ratings_columns
    drop_table :posts
  end
end

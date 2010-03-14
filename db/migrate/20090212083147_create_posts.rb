class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :post_category, :null => false
      t.string :title, :null => false
      t.text :description, :null => false
      t.belongs_to :school, :null => false
      t.string :email
      t.boolean :use_this_email
      t.boolean :allow_comment, :default => 1
      t.boolean :allow_response, :default => 1
      t.boolean :allow_rate, :default => 1
      t.boolean :allow_download, :default => 1
      t.string :type_name

      t.timestamps
    end
  end

  def self.down
    # Remove the columns we added
    Post.remove_ratings_columns
    drop_table :posts
  end
end

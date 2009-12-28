class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :post_category, :null => false
      t.string :title, :null => false
      t.text :description, :null => false
      t.belongs_to :school, :null => false
      t.belongs_to :department, :null => false
      t.string :email, :null => false
      t.boolean :use_this_email
      t.string :telephone
      t.boolean :allow_comment, :default => 1
      t.boolean :allow_response, :default => 1
      t.boolean :allow_rate, :default => 1
      t.boolean :allow_download, :default => 1
      t.string :type_name
      t.string :school_year

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end

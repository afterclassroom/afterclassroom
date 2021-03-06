class CreateComments < ActiveRecord::Migration
  def self.up
    create_table "comments", :force => true do |t|
      t.string "title", :limit => 50, :default => ""
      t.text "comment"
      t.datetime "created_at", :null => false
      t.integer "commentable_id", :default => 0, :null => false
      t.string "commentable_type", :limit => 15, :default => "", :null => false
      t.integer "user_id", :default => 0, :null => false
    end
  
    add_index "comments", ["user_id"], :name => "fk_comments_user"
  end

  def self.down
    drop_table :comments
  end
end

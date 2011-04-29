# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string :title
      t.string :content
      t.belongs_to :user, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :forums
  end
end

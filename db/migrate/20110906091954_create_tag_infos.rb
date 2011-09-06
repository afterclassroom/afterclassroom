class CreateTagInfos < ActiveRecord::Migration
  def self.up
    create_table :tag_infos do |t|
      t.integer :tag_creator_id
      t.integer :tagable_id #id of the Photo/Video to be tagged
      t.string :tagable_type
      t.integer :tagable_user
      t.boolean :verify

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_infos
  end
end

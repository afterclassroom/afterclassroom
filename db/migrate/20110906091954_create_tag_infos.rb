class CreateTagInfos < ActiveRecord::Migration
  def self.up
    create_table :tag_infos do |t|
      t.integer :tag_creator_id
      t.integer :tagable_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_infos
  end
end

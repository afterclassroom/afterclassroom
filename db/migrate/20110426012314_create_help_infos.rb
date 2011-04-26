class CreateHelpInfos < ActiveRecord::Migration
  def self.up
    create_table :help_infos do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :help_infos
  end
end

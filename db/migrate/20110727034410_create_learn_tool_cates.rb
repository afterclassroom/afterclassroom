class CreateLearnToolCates < ActiveRecord::Migration
  def self.up
    create_table :learn_tool_cates do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :learn_tool_cates
  end
end

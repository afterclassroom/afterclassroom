class CreatePostTeamups < ActiveRecord::Migration
  def self.up
    create_table :post_teamups do |t|
      t.belongs_to :post, :null => false
      t.belongs_to :teamup_category, :null => false
      t.string :ourStatus
      t.string :founded_in
      t.string :noOfMember
      t.string :rating_status
    end
  end

  def self.down
    drop_table :post_teamups
  end
end

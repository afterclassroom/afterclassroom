class CreatePostTeamups < ActiveRecord::Migration
  def self.up
    create_table :post_teamups do |t|
      t.belongs_to :post, :null => false
      t.belongs_to :teamup_category, :null => false
      t.string :opportunity_type
      t.string :position_title
      t.string :expected_time_commit
      t.belongs_to :functional_experience
      t.string :compensation_offered
      t.boolean :teamupType #true: teamup for Sport
      t.string :ourStatus
      t.string :founded_in
      t.string :noOfMember
    end
  end

  def self.down
    drop_table :post_teamups
  end
end

class CreateAwarenessIssuesPostAwarenesses < ActiveRecord::Migration
  def self.up
    create_table :awareness_issues_post_awarenesses, :id => false do |t|
      t.belongs_to :post_awareness, :null => false
      t.belongs_to :awareness_issue, :null => false
    end
  end

  def self.down
    drop_table :awareness_issues_post_awarenesses
  end
end

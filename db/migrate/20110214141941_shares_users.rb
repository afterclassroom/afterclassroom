class SharesUsers < ActiveRecord::Migration
  def self.up
    create_table :shares_users, :id => false do |t|
      t.belongs_to :share
      t.belongs_to :user
    end
  end

  def self.down
    drop_table :shares_users
  end
end

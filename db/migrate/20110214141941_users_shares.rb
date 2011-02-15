class UsersShares < ActiveRecord::Migration
  def self.up
    create_table :users_shares do |t|
      t.belongs_to :user
      t.belongs_to :share
    end
  end

  def self.down
    drop_table :users_shares
  end
end

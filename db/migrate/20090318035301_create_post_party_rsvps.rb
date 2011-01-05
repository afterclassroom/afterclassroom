class CreatePostPartyRsvps < ActiveRecord::Migration
  def self.up
    create_table :post_party_rsvps do |t|
      t.belongs_to :post_party
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :tel
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :post_party_rsvps
  end
end

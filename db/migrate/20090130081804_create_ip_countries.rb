class CreateIpCountries < ActiveRecord::Migration
  def self.up
    create_table :ip_countries do |t|
      t.string :ip_address
      t.string :ip_code
      t.string :country
      t.string :state
      t.string :city
    end
  end

  def self.down
    drop_table :ip_countries
  end
end

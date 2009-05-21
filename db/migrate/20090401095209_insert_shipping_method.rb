class InsertShippingMethod < ActiveRecord::Migration
  def self.up
    ["FedEx",
      "UPS",
      "USPO"
    ].each do |s|
      ShippingMethod.new(:name => s).save
    end
  end

  def self.down
  end
end

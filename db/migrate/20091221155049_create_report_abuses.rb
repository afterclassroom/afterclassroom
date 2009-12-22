class CreateReportAbuses < ActiveRecord::Migration
  def self.up
    create_table :report_abuses do |t|
      t.belongs_to :user
      t.belongs_to :post
      t.belongs_to :report_abuse_category
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :report_abuses
  end
end

class CreateReportAbuses < ActiveRecord::Migration
  def self.up
    create_table :report_abuses do |t|
      t.belongs_to :report_abuse_category
      t.integer :reporter_id
      t.integer :reported_id
      t.string :reported_type
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :report_abuses
  end
end

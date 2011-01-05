class CreateReportAbuseCategories < ActiveRecord::Migration
  def self.up
    create_table :report_abuse_categories do |t|
      t.string :name
    end
    
    ["Report Abuse 1",
    "Report Abuse 2",
    "Report Abuse 3",
    "Report Abuse 4"
   ].each do |s|
      ReportAbuseCategory.new(:name => s).save
    end
  end

  def self.down
    drop_table :report_abuse_categories
  end
end

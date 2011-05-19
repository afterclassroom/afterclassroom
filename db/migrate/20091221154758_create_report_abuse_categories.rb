class CreateReportAbuseCategories < ActiveRecord::Migration
  def self.up
    create_table :report_abuse_categories do |t|
      t.string :name
    end
    
    ["Verbal abuse",
    "Psychological abuse",
    "Hate crimes",
    "Racism"
   ].each do |s|
      ReportAbuseCategory.new(:name => s).save
    end
  end

  def self.down
    drop_table :report_abuse_categories
  end
end

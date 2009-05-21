class InsertJobTypes < ActiveRecord::Migration
  def self.up
    ["Full-time Permanent",
      "Full-time Temporary",
      "Part-time Permanent",
      "Part-time Temporary",
      "Contractor/Consultant",
      "Internship",
      "Other"
    ].each do |s|
      JobType.new(:name => s).save
    end
  end

  def self.down
  end
end
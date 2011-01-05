class AddRatingTables < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.create_ratings_table
    ActiveRecord::Base.create_ratings_table :with_rater => false, :table_name => 'no_rater_ratings'
    ActiveRecord::Base.create_ratings_table :with_stats_table => true, :table_name => 'stats_ratings' 
    ActiveRecord::Base.create_ratings_table :with_stats_table => true, :table_name => 'my_stats_ratings', :stats_table_name => 'my_statistics'
  end

  def self.down
    ActiveRecord::Base.drop_ratings_table
    ActiveRecord::Base.drop_ratings_table :table_name => 'no_rater_ratings'
    ActiveRecord::Base.drop_ratings_table :with_stats_table => true, :table_name => 'stats_ratings'                                          
    ActiveRecord::Base.drop_ratings_table :with_stats_table => true, :table_name => 'my_stats_ratings', :stats_table_name => 'my_statistics' 
  end
end

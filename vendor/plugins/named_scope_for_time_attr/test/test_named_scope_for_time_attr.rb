require File.dirname(__FILE__) + '/test_helper.rb'

# The ActiveRecord test model. 
# Note: we don't need a database as long as we only build named scopes.
class Claim < ActiveRecord::Base
  named_scope_for_time_attr :created_at
  named_scope_for_time_attr :updated_at, :order => 'name DESC'
end

# Simulate a constant time. 
# You can use mocha for this but than you have one dependency more.
class Time
  def self.now
    Time.mktime(2009,3,1,12,0,0)
  end
end

class TestNamedScopeForTimeAttr < Test::Unit::TestCase

  # #TODO/2009-03-02/tb 
  # tests gehen nicht auf die DB, d.h. das Statement wird nicht wirklich ausgeführt. ist das gut?

  def test_scope_with_today
    assert_conditions("2009-03-01  00:00:00", "2009-03-01 23:59:59", :today)
  end

  def test_scope_with_yesterday
    assert_conditions("2009-02-28 00:00:00", "2009-02-28 23:59:59", :yesterday)
  end

  def test_scope_with_tomorrow
    assert_conditions("2009-03-02 00:00:00", "2009-03-02 23:59:59", :tomorrow)
  end

  def test_scope_with_this_week           
    assert_conditions("2009-02-23 00:00:00", "2009-03-01 23:59:59", :this_week)
  end                                     
                                          
  def test_scope_with_last_week           
    assert_conditions("2009-02-16 16 00:00:00", "2009-02-22 23:59:59", :last_week)
  end                                                            
                                                                 
  def test_scope_with_next_week                                  
    assert_conditions("2009-03-02 00:00:00", "2009-03-08 23:59:59", :next_week)
  end                                                            
                                                                 
  def test_scope_with_this_month                                 
    assert_conditions("2009-03-01 00:00:00", "2009-03-31 23:59:59", :this_month)
  end                                                            
                                                                 
  def test_scope_with_last_month                                 
    assert_conditions("2009-02-01 00:00:00", "2009-02-28 23:59:59", :last_month)
  end                                                            
                                                                 
  def test_scope_with_next_month                                 
    assert_conditions("2009-04-01 00:00:00", "2009-04-30 23:59:59", :next_month)
  end                                                            

  def test_scope_with_this_quarter                                         
    assert_conditions("2009-01-01 00:00:00", "2009-03-31 23:59:59", :this_quarter)
  end                                                            
                                                                 
  def test_scope_with_q1                                         
    assert_conditions("2009-01-01 00:00:00", "2009-03-31 23:59:59", :q1)
  end                                                            
                                                                 
  def test_scope_with_q2                                         
    assert_conditions("2009-04-01 00:00:00", "2009-06-30 23:59:59", :q2)
  end

  def test_scope_with_q3
    assert_conditions("2009-07-01 00:00:00", "2009-09-30 23:59:59", :q3)
  end                                                            
                                                                 
  def test_scope_with_q4                                         
    assert_conditions("2009-10-01 00:00:00", "2009-12-31 23:59:59", :q4)
  end                                                            
                                                                 
  def test_scope_with_this_year                                  
    assert_conditions("2009-01-01 00:00:00", "2009-12-31 23:59:59", :this_year)
  end                                                            
                                                                 
  def test_scope_with_last_year                                  
    assert_conditions("2008-01-01 00:00:00", "2008-12-31 23:59:59", :last_year)
  end                                      
                                           
  def test_scope_with_next_year            
    assert_conditions("2010-01-01 00:00:00", "2010-12-31 23:59:59", :next_year)
  end

  def test_scope_for_created_at_without_order
    assert_nil Claim.created_at(:today).proxy_options[:order]
  end

  def test_scope_for_updated_at_with_order
    assert_equal "name DESC", Claim.updated_at(:today).proxy_options[:order]
  end

  private

    def assert_conditions(start_time, end_time, time_key)
      assert_equal expected_options(start_time, end_time), Claim.created_at(time_key).proxy_options
    end

    def expected_options(start_time, end_time)
      {:conditions => ["claims.created_at >= ? AND claims.created_at <= ?", 
          Time.parse(start_time), Time.parse(end_time)]}
    end
end



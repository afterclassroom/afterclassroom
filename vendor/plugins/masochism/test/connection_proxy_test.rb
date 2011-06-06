require 'test/unit'
require 'mocha'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'active_reload/connection_proxy'
require 'active_reload/master_filter'

RAILS_ENV = 'test'

module Rails
  def self.env() RAILS_ENV end
end

class MasochismTestCase < ActiveSupport::TestCase
  setup do
    ActiveRecord::Base.configurations = default_configuration
  end
  
  def self.default_configuration
    { Rails.env => {'adapter' => 'sqlite3', 'database' => ':memory:'} }
  end
  
  def config
    ActiveRecord::Base.configurations
  end
  
  def connection
    ActiveRecord::Base.connection
  end
  
  def enable_masochism
    ActiveReload::ConnectionProxy.setup!
  end
  
  def master
    connection.master
  end
  
  def slave
    connection.slave
  end
end

class ConnectionProxyTest < MasochismTestCase
  setup do
    ActiveRecord::Base.establish_connection
  end
  
  teardown do
    [ActiveRecord::Base, ActiveReload::MasterDatabase, ActiveReload::SlaveDatabase].each do |klass|
      klass.remove_connection
    end
  end
  
  def create_table
    master.create_table(:foo) {|t|}
  end
  
  def test_slave_defined_returns_false_when_slave_not_defined
    assert !ActiveReload::ConnectionProxy.slave_defined?, 'Slave should not be defined'
  end

  def test_slave_defined_returns_true_when_slave_defined
    config.update('slave_database' => {})
    assert ActiveReload::ConnectionProxy.slave_defined?, 'Slave should be defined'
  end

  def test_default
    enable_masochism
    create_table
    
    assert_equal ['foo'], slave.tables, 'Master and Slave should be the same database'
  end

  def test_master_database_outside_environment
    config.update('master_database' => config[Rails.env].dup)
    enable_masochism
    create_table

    assert_equal [], slave.tables, 'Master and Slave should be different databases'
  end

  def test_master_database_within_environment
    config[Rails.env].update('master_database' => config[Rails.env].dup)
    enable_masochism
    create_table

    assert_equal [], slave.tables, 'Master and Slave should be different databases'
  end

  def test_slave_database_within_environment
    config[Rails.env].update('slave_database' => config[Rails.env].dup)
    enable_masochism
    create_table

    assert_equal [], slave.tables, 'Master and Slave should be different databases'
  end
end

class DelegatingTest < MasochismTestCase
  setup :place_mocks
  
  def place_mocks
    # this doesn't actually establish any connections,
    # but we don't need them
    enable_masochism
    @master = mock
    @slave = mock
    connection.stubs(:master).returns(@master)
    connection.stubs(:slave).returns(@slave)
  end
  
  def test_connection_is_a_proxy
    assert_equal 'ActiveReload::ConnectionProxy', connection.class.name
  end
  
  def test_masochistic
    assert connection.masochistic?
  end
  
  def test_reads_go_to_slave
    @slave.expects(:select_rows).with('SELECT').returns(['bar'])
    assert_equal ['bar'], connection.select_rows('SELECT')
  end
  
  def test_writes_go_to_master
    @master.expects(:insert).with('INSERT').returns(1)
    assert_equal 1, connection.insert('INSERT')
  end
  
  def test_execute_gos_to_master
    @master.expects(:execute).with('QUERY').returns('result')
    assert_equal 'result', connection.execute('QUERY')
  end
  
  def test_with_master
    @master.expects(:select_rows).returns(['foo'])
    @slave.expects(:select_rows).returns(['bar'])
    
    connection.with_master do
      assert_equal ['foo'], connection.select_rows
    end
    assert_equal ['bar'], connection.select_rows
  end
  
  def test_transactions_run_on_master
    @master.expects(:transaction).with(:foo => 'bar').yields
    
    assert_equal :slave, connection.current_type
    
    ActiveRecord::Base.transaction(:foo => 'bar') do
      # hardcore transaction stuff
      assert_equal :master, connection.current_type
    end
    assert_equal :slave, connection.current_type
  end
end

class MasterFilterTest < MasochismTestCase
  setup :prepare
  
  def prepare
    enable_masochism
    @controller = mock
  end
  
  def test_yields_in_master_block
    yielded = false
    ActiveReload::MasterFilter.filter(@controller) do
      assert_equal :master, connection.current_type
      yielded = true
    end
    assert yielded
  end
  
  def test_doesnt_yield_in_master_without_masochism
    connection.expects(:masochistic?).returns(false)
    
    yielded = false
    ActiveReload::MasterFilter.filter(@controller) do
      assert_equal :slave, connection.current_type
      yielded = true
    end
    assert yielded
  end
  
  def test_instance_mode
    model = mock
    model.stubs(:connection).returns(connection)
    
    yielded = false
    ActiveReload::MasterFilter.new(model).filter(@controller) do
      assert_equal :master, connection.current_type
      yielded = true
    end
    assert yielded
  end
  
  def test_instance_mode_without_masochism
    model = mock
    conn = mock
    model.stubs(:connection).returns(conn)
    conn.expects(:masochistic?).returns(false)
    
    yielded = false
    ActiveReload::MasterFilter.new(model).filter(@controller) do
      yielded = true
    end
    assert yielded
  end
end
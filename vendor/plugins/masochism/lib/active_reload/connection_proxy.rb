module ActiveReload
  class MasterDatabase < ActiveRecord::Base
    self.abstract_class = true
  end

  class SlaveDatabase < ActiveRecord::Base
    self.abstract_class = true
  end
  
  # replaces the object at ActiveRecord::Base.connection to route read queries
  # to slave and writes to master database
  class ConnectionProxy
    def initialize(master_class, slave_class)
      @master = master_class
      @slave = slave_class
      @thread_key = :"#{@slave}_#{self}_type"
    end

    def master
      @master.retrieve_connection
    end

    def slave
      @slave.retrieve_connection
    end

    def self.setup!
      if slave_defined?
        setup_for ActiveReload::MasterDatabase, ActiveReload::SlaveDatabase
      else
        setup_for ActiveReload::MasterDatabase
      end
    end

    def self.slave_defined?
      !!configuration_for(:slave)
    end
    
    def self.configuration_for(type)
      config, key = ActiveRecord::Base.configurations, "#{type}_database"
      config[Rails.env][key] || config[key]
    end

    def self.setup_for(master, slave = nil)
      slave ||= ActiveRecord::Base
      
      unless slave.respond_to?(:connection_proxy=)
        slave.__send__(:include, ActiveRecordConnectionMethods)
      end
      unless ActiveRecord::Observer.instance_methods.include?('update_with_master')
        ActiveRecord::Observer.__send__(:include, ActiveReload::ObserverExtensions)
      end
      
      # wire up MasterDatabase and SlaveDatabase
      establish_connections
      slave.connection_proxy = new(master, slave)
    end
    
    def self.establish_connections
      [:master, :slave].each { |type| establish_connection_for(type) }
    end
    
    def self.establish_connection_for(type)
      if connection_spec = configuration_for(type)
        klass = ActiveReload::const_get("#{type}_database".camelize)
        klass.establish_connection(connection_spec)
      end
    end
    
    # retrieve connection to currently selected database
    def current
      send current_type
    end
    
    def current_type
      Thread.current[@thread_key] ||= :slave
    end
    
    def current_type=(type)
      Thread.current[@thread_key] = type
    end

    def with_master
      old_type = current_type
      self.current_type = :master
      yield
    ensure
      self.current_type = old_type
    end

    def set_to_master!
      unless current_type == :master
        @slave.logger.info "Switching to master"
        self.current_type = :master
      end
    end

    def set_to_slave!
      unless current_type == :slave
        @master.logger.info "Switching to slave"
        self.current_type = :slave
      end
    end
    
    delegate :execute, :insert, :update, :delete,
      :add_column, :add_index, :add_timestamps, :assume_migrated_upto_version, :change_column,
      :change_column_default, :change_column_null, :change_table, :create_database, :create_table,
      :disable_referential_integrity, :drop_database, :drop_table, :initialize_schema_migrations_table,
      :insert_fixture, :recreate_database, :remove_column, :remove_columns, :remove_index,
      :remove_timestamps, :rename_column, :rename_table, :reset_sequence!,
      :to => :master

    def transaction(options = {}, &block)
      with_master do
        master.transaction(options, &block)
      end
    end

    def method_missing(method, *args, &block)
      current.send(method, *args, &block)
    end
    
    def respond_to?(method)
      super or current.respond_to?(method)
    end
    
    def methods
      super | current.methods
    end
    
    def masochistic?
      true
    end
  end

  module ActiveRecordConnectionMethods
    def self.included(base)
      base.alias_method_chain :reload, :master

      class << base
        def connection_proxy=(proxy)
          @@connection_proxy = proxy
        end

        # hijack the original method
        def connection
          @@connection_proxy
        end
      end
    end
    
    # reload performs a find, but is usually used after a write, so we lock it
    # to master since we can't depend on slave replication being so fast
    def reload_with_master(options = nil)
      connection.with_master { reload_without_master(options) }
    end
  end

  # make observers always use the master database
  module ObserverExtensions
    def self.included(base)
      base.alias_method_chain :update, :master
    end

    # Send observed_method(object) if the method exists.
    def update_with_master(observed_method, object)
      if object.respond_to?(:connection) && object.connection.masochistic?
        object.connection.with_master do
          update_without_master(observed_method, object)
        end
      else
        update_without_master(observed_method, object)
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  def masochistic?
    false
  end
end
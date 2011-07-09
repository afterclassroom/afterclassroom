masochism
=========

<div style="width:240px; padding:2px; border:1px solid silver; float:right; margin:0 0 1em 2em; background:white">
  <img src="http://farm1.static.flickr.com/111/295426387_a39c5c8954_m.jpg" alt="Scream" />
  <p style="text-align:center">photo by <a href="http://flickr.com/people/alphadesigner/" title="Flickr: ArtWerk">ArtWerk</a></p>
</div>

The masochism plugin provides an easy solution for Ruby on Rails applications to work in a
replicated database environment. It works by replacing the `connection` object accessed by
ActiveRecord models by ConnectionProxy that chooses between master and slave when
executing queries. Generally all writes go to master.


Quick setup
-----------

First, setup your database.yml:

    # default configuration (slave)
    production: &defaults
      adapter: mysql
      database: app_production
      username: webapp
      password: ********
      host: localhost

    # setup for masochism (master)
    master_database:
      <<: *defaults
      host: master.example.com

To enable masochism, this call is required:

    # enable masochism
    ActiveReload::ConnectionProxy.setup!

Example usage for a Rails application:
    
    # in environment.rb
    config.after_initialize do
      if Rails.env.production?
        ActiveReload::ConnectionProxy::setup!
      end
    end


Considerations
--------------

### Thinking Sphinx

Thinking Sphinx inspects the `connection` object to determine the database adapter.
Because masochism works by putting the connection proxy in its place, TS will get confused
about `ActiveReload::ConnectionProxy` and abort. A possible workaround is to monkeypatch
TS right to **hardcode** our adapter after masochism has been enabled:

    # ConnectionProxy from masochism confuses TS
    ThinkingSphinx::Index.class_eval do
      def adapter() :mysql end
    end

    ThinkingSphinx::AbstractAdapter.class_eval do
      def self.detect(model)
        ThinkingSphinx::MysqlAdapter
      end
    end

In newer versions of Thinking Sphinx (observed in 1.1.3), different parts have to be patched:

    # for ThinkingSphinx v1.1.3
    ThinkingSphinx::AbstractAdapter.class_eval do
      def self.detect(model)
        adapter = model.connection.adapter_name
        case adapter
        when 'MySQL'
          ThinkingSphinx::MysqlAdapter.new(model)
        when 'PostgreSQL'
          ThinkingSphinx::PostgreSQLAdapter.new(model)
        else
          raise "Invalid database adapter #{adapter.inspect}: Sphinx only supports MySQL and PostgreSQL"
        end
      end
    end

    ThinkingSphinx::Index.class_eval do
      # we have to overwrite this method because it tries to access
      # @model.connection.instance_variable_get(:@config)
      def set_source_database_settings(source)
        config = @model.configurations[Rails.env].symbolize_keys

        source.sql_host = config[:host]           || "localhost"
        source.sql_user = config[:username]       || config[:user] || ""
        source.sql_pass = (config[:password].to_s || "").gsub('#', '\#')
        source.sql_db   = config[:database]
        source.sql_port = config[:port]
        source.sql_sock = config[:socket]
      end
    end
    

### Litespeed web server or Phusion Passenger (mod\_rails)

If you are using the Litespeed web server or Passenger (mod\_rails), child processes are initialized on creation,
which means any setup done in an environment file will be effectively ignored. [A brief
discussion of the problem is posted here](http://litespeedtech.com/support/wiki/doku.php?id=litespeed_wiki:rails:memcache).

One solution for Litespeed/Passenger users is to check the connection at your first request and do
the `setup!` call if your connection hasn't been initialized, like:

    # in ApplicationController
    prepend_before_filter do |controller|
      unless ActiveRecord::Base.connection.is_a? ActiveReload::ConnectionProxy
        ActiveReload::ConnectionProxy.setup!
      end
    end


Advanced
--------

The ActiveReload::MasterDatabase and ActiveReload::SlaveDatabase abstract models use the
'master\_database' and 'slave\_database' settings, respectively.

In 'database.yml' configuration file, both settings can be specified either per-environment or
global (like in the first example of this document).

Examples:

    login: &login
      adapter: postgresql
      host: localhost
      port: 5432
    
    production:
      database: production_slave_database_name
      <<: *login
    
    master_database:
      database: production_master_database_name
      <<: *login
    
    staging:
      database: staging_database_name
      host: slave-db-pool.local
      <<: *login
      master_database: 
        database: staging_database_name
        host: master-db-server.local
        <<: *login
    
    qa:
      database: qa_master_database_name
      host: qa-master
      <<: *login
      slave_database:
        database: qa_slave_database_name
        host: qa-slave
        <<: *login
    
    development: # Does not use masochism
      database: development_database_name
      <<: *login
 
If you want a model to always use the Master database, you can inherit
`ActiveReload::MasterDatabase`. Any models with their own database connection will not be
affected.

### More control at setup

By default, masochism `setup!` is a shorthand for this:

    ActiveReload::ConnectionProxy.setup_for ActiveReload::MasterDatabase, ActiveRecord::Base

The first argument is the model that has the master database connection established; the
second argument is the model whose `connection` gets hijacked by ConnectionProxy. But we
don't have to touch `ActiveRecord::Base` at all:

    # set up MyMaster's connection as the master database connection for User:
    ActiveReload::ConnectionProxy.setup_for MyMaster, User

### The controller filter

If you have any actions you know require the master database for both reads and writes,
simply do the following:

    # in a controller:
    around_filter ActiveReload::MasterFilter, :only => [:show, :edit, :update]

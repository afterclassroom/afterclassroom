module ActiveReload
  # MasterFilter is an around filter for controllers that require certain actions
  # to use the master database for both reads and writes
  #
  # Usage:
  #   # class level:
  #   around_filter ActiveReload::MasterFilter
  #   
  #   # instance level:
  #   around_filter ActiveReload::MasterFilter.new(MyModel)
  class MasterFilter
    def self.filter(controller, &block)
      with_master(&block)
    end
    
    def self.with_master(klass = ActiveRecord::Base)
      if klass.connection.masochistic?
        klass.connection.with_master { yield }
      else
        yield
      end
    end
    
    def initialize(klass)
      @klass = klass
    end
    
    def filter(controller, &block)
      self.class.with_master(@klass, &block)
    end
  end
end
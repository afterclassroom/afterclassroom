$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'active_record'

module NamedScopeForTimeAttr
  VERSION = '1.0.0'
end

require File.expand_path(File.dirname(__FILE__) + '/named_scope_for_time_attr/named_scope_for_time_attr')

# include the method in ActiveRecord::Base so it is available in all models by default
ActiveRecord::Base.class_eval do
  include NamedScopeForTimeAttr
end
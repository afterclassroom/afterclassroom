module NamedScopeForTimeAttr #:nodoc:

  def self.included(base)
    base.extend ClassMethods 
  end

  module ClassMethods

    ##
    # Provides the <tt>ActiveRecord</tt> helper method <tt>named_scope_for_time_attr</tt>.  
    # Given the name of a time attribute of an ActiveRecord model 
    # (e.g. <tt>created_at</tt> of <tt>Claim</tt>) it defines a correspondent
    # named scope for easy access to an arbitrarily time range (scope).
    #
    # ==== Examples
    #
    #   class Claim < ActiveRecord::Base
    #     named_scope_for_time_attr :created_at, :order => 'created_at DESC'
    #     named_scope_for_time_attr :updated_at
    #     named_scope_for_time_attr :last_modified_on, :limit => 10
    #     ...
    #   end
    #
    # It is then possible to use the scope method <tt>created_at</tt> and <tt>updated_at</tt>
    # as follows:
    #
    #   Claim.created_at(2.days.ago)
    #   Claim.updated_at(2.days.ago, 1.days.ago)
    #   Claim.last_modified_on(3.weeks.ago)
    #
    # Is is even possible to use one of the following predefined keys to specify a time range:
    #
    # * <tt>:today</tt>
    # * <tt>:yesterday</tt>
    # * <tt>:tomorrow</tt>
    # * <tt>:this_week</tt>
    # * <tt>:last_week</tt>
    # * <tt>:next_week</tt>
    # * <tt>:this_month</tt>
    # * <tt>:last_month</tt>
    # * <tt>:next_month</tt>
    # * <tt>:this_quarter</tt>
    # * <tt>:last_quarter</tt>
    # * <tt>:next_quarter</tt>
    # * <tt>:q1</tt>
    # * <tt>:q2</tt>
    # * <tt>:q3</tt>
    # * <tt>:q4</tt>
    # * <tt>:this_year</tt>
    # * <tt>:last_year</tt>
    # * <tt>:next_year</tt>
    #
    # And use them as follows:
    # 
    #   Claim.created_at(:today)
    #   Claim.updated_at(:this_month)
    #   Claim.last_modified_on(:last_year)
    #   Claim.created_at(:q1) # quarter one
    #   Claim.created_at(:this_quarter)
    #
    # One can specify additional conditional options to <tt>named_scope_for_time_attr</tt> 
    # to sort or limit the list of object loaded:
    #
    #   class Claim < ActiveRecord::Base
    #     named_scope_for_time_attr :created_at, :order => 'created_at DESC'
    #     named_scope_for_time_attr :updated_at, :limit => 10
    #     ...
    #   end
    #
    # The definition also provide a scope <tt>order</tt> to ordered the list which is used
    # as follows:
    #
    #   Claim.updated_at(:yesterday).order(:updated_at) # => ... ORDER BY created_at
    #   Claim.updated_at(:last_week).order('updated_at DESC') # => ... ORDER BY updated_at DESC
    #   Claim.updated_at(:yesterday).order('shortname') # => ... ORDER BY shortname
    #
    def named_scope_for_time_attr(attr_name, options = {})
      named_scope attr_name, lambda { |*args| build_conditions("#{table_name}.#{attr_name}", *args).merge(options) }
      named_scope :order, lambda { |*args| {:order => (args.first || "#{attr_name} DESC") } }
    end
  
    private

      QUARTER_KEYS = [:this_quarter, :last_quarter, :next_quarter, :q1, :q2, :q3, :q4]
      QUARTER_MONTHS = { 1 => [1,3], 2 => [4,6], 3 => [7,9], 4 => [10,12] }
      MAP_TIME = {
        :today        => [ 0, :day],
        :yesterday    => [ 1, :day],
        :tomorrow     => [-1, :day],
        :this_week    => [ 0, :week],
        :last_week    => [ 1, :week],
        :next_week    => [-1, :week],
        :this_month   => [ 0, :month],
        :last_month   => [ 1, :month],
        :next_month   => [-1, :month],
        :this_year    => [ 0, :year],
        :last_year    => [ 1, :year],
        :next_year    => [-1, :year]
      }

      ##
      # Examples:
      #   build_conditions(:created_at, :last_week)
      #   build_conditions(:created_at, 2.days.ago, 1.days.ago)
      #   build_conditions(:created_at, 3.hours.ago)
      #
      def build_conditions(attr_name, *args)
        if QUARTER_KEYS.include?(args.first)
          quarter_range_conditions(attr_name, args.first)
        elsif args.first.kind_of?(Symbol)
          count, key = MAP_TIME[args.first]
          time_range_conditions_ago(attr_name, count || 0, key || args.first)
        elsif args.size == 2
          time_range_conditions(attr_name, args.first, args.last)
        else 
          {:conditions => ["#{attr_name} >= ?", args.first]}
        end
      end

      ##
      # Examples:
      #   time_range_conditions_ago(:created_at, 0, :day)
      #   time_range_conditions_ago(:created_at, 1, :week)
      #
      def time_range_conditions_ago(attr_name, count, key)
        eval("time_range_conditions(attr_name, #{count}.#{key}.ago.beginning_of_#{key}, #{count}.#{key}.ago.end_of_#{key})")
      end

      def time_range_conditions(attr_name, start_time, end_time)
        {:conditions => ["#{attr_name} >= ? AND #{attr_name} <= ?", start_time, end_time]}
      end

      def quarter_range_conditions(attr_name, quarter)
        year = Time.now.year
        if quarter.to_s =~ /^q\d{1}/
          quarter = quarter.to_s[1,1].to_i
        else
          month = Time.now.month
          q = #TODO/2009-03-02/tb better code 
            if month < 4
              1
            elsif month < 7
              2
            elsif month < 10
              3
            else
              4
            end
          quarter = q   if quarter == :this_quarter  
          quarter = q-1 if quarter == :last_quarter  
          quarter = q+1 if quarter == :next_quarter  
          quarter > 4 ? 1 : (quarter < 1 ? 4 : quarter)
        end
        start_month, end_month = QUARTER_MONTHS[quarter]
        time_range_conditions(attr_name, 
          Time.mktime(year, start_month).beginning_of_month, 
          Time.mktime(year, end_month).end_of_month)
      end

  end
end


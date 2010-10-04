class PostExamSchedule < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :school

  # Named Scope
  named_scope :with_limit, :limit => LIMIT
  named_scope :with_type, lambda { |tp| {:conditions => ["type_name = ?", tp]} }
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:conditions => ["school_id = ?", sc], :order => "created_at DESC"}}

  def self.paginated_post_conditions_with_type(params, school, type)
    PostExamSchedule.with_school(school).with_type(type).paginate :page => params[:page], :per_page => 10
  end
end

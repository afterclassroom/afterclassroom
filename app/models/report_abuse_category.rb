class ReportAbuseCategory < ActiveRecord::Base
	has_many :report_abuses
end

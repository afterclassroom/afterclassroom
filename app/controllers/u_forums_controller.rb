class UForumsController < ApplicationController

  layout 'student_lounge'

  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user

end

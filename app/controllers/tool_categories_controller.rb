class ToolCategoriesController < ApplicationController
  require_role :admin
  layout 'admin'
end

class Manager::ApplicationController < ApplicationController
  before_filter :pundit_manager
  layout "new_version_manager"
end

class Manager::ApplicationController < ApplicationController
  before_filter :pundit_manager
  layout "new_version_manager"

  protected
  def pundit_manager
    authorize :manager, "#{action_name}?"
  end
end

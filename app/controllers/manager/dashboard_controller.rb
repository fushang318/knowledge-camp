class Manager::DashboardController < Manager::ApplicationController
  include ApplicationHelper

  def index
    @page_name = "manager_dashboard"
    @component_data = {
      scenes: 
        current_user.role == "admin" ?
          manager_sidebar_scenes :
          supervisor_sidebar_scenes
    }
    render "/mockup/page"
  end
end

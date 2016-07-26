class Manager::SupervisorTellersController < Manager::ApplicationController
  def index
    @page_name = "manager_supervisor_tellers"
#
    users = User.with_role(:teller).page(params[:page])
    data    = users.map do |x|
      DataFormer.new(x)
        .logic(:phone_number)
        .data
    end

    @component_data = {
      users: data,
      paginate: {
        total_pages: users.total_pages,
        current_page: users.current_page,
        per_page: users.limit_value
      }
    }
  end
end


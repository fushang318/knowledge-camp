class Manager::SupervisorsController < Manager::ApplicationController
  def index
    @page_name = "manager_supervisors"
#
    users = User.with_role(:supervisor).page(params[:page])
    data    = users.map do |x|
      DataFormer.new(x)
        .url(:manager_supervisors_edit_url)
        .data
    end

    @component_data = {
      new_supervisor_url: new_manager_supervisor_path,
      users: data,
      paginate: {
        total_pages: users.total_pages,
        current_page: users.current_page,
        per_page: users.limit_value
      }
    }
  end

  def new
    @page_name = "manager_new_supervisor"
    @component_data = {
      create_supervisor_url: manager_supervisors_path
    }
  end

  def create
    user = User.new(user_create_params)
    user.role = :supervisor
    save_model(user) do |c|
      DataFormer.new(c)
          .data
        .merge jump_url: manager_supervisors_path
    end
  end

  def edit
    user = User.find params[:id]
    @page_name = "manager_edit_supervisor"
    @component_data = {
      user: DataFormer.new(user).data,
      update_url: manager_supervisor_path(user)
    }
  end

  def update
    user = User.find params[:id]

    update_model(user, user_update_params) do |x|
      DataFormer.new(x)
        .data
      .merge jump_url: manager_supervisors_path
    end
  end

  def user_create_params
    params.require(:users).permit(:name, :email, :password)
  end

  def user_update_params
    uup = params.require(:users).permit(:name, :email, :password)
    uup.delete "password" if uup["password"].blank?
    uup
  end
end

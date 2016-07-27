class RegistrationsController < Devise::RegistrationsController
  layout "new_version_base"
  skip_before_action :verify_authenticity_token, :only => :create, :if => :request_is_xhr
  def request_is_xhr
    request.xhr?
  end

  def new
    @page_name = 'auth_bank_sign_up'
    posts = EnterprisePositionLevel::Post.all.map do |post|
      DataFormer.new(post).data
    end

    @component_data = {
      posts: posts,
      get_activate_code_url:   e_phone_number_check_mod.messages_path,
      valid_activate_code_url: e_phone_number_check_mod.check_validation_messages_path,
      check_phone_number_url:  api_check_phone_number_path,
      sign_in_url: sign_in_path,
      sign_up_url: sign_up_path,
      submit_url: api_sign_up_path
    }
    render "/mockup/page", layout: 'mockup_bank_auth'
  end

  def edit
    @component_data = {
      user: DataFormer.new(current_user).logic(:role).data,
      update_url: "/users"
    }

    if current_user.role.admin? || current_user.role.supervisor?
      @page_name = 'admin_or_supervisor_edit'
      render "/mockup/page", layout: 'new_version_manager'
    else
      @page_name = 'user_edit'
      render "/mockup/page", layout: 'new_version_base'
    end
  end

  def update
    if current_user.role.admin? || current_user.role.supervisor?
      result = _update_admin_or_supervisor
    else
      result = _update_teller
    end

    if result
      data = DataFormer.new(current_user).data.merge jump_url: "/"
      sign_in current_user, :bypass => true
      render json: data
    else
      data = current_user.errors.messages
      render json: data, :status => 422
    end
  end

  def _update_admin_or_supervisor
    user_params = params.require(:users).permit(:password, :current_password)
    current_user.update_with_password(user_params)
  end

  def _update_teller
    user_params = params.require(:users).permit(:name, :password, :current_password)
    user_params.delete :password if user_params[:password].blank?

    if user_params[:current_password].blank?
      return current_user.update_without_password(user_params)
    else
      return current_user.update_with_password(user_params)
    end
  end

  def check_phone_number
    user = User.where(phone_number: params[:phone_number]).first
    if user.blank?
      render json: {text: '手机号码可以使用', status: 200}, status: 200
    else
      render json: {text: '手机号码已经被使用了', status: 422}, status: 422
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :phone_number, :post_id, :password) }
  end

end

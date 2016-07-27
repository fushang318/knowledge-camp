class IndexController < ApplicationController
  layout "new_version_base"

  def index
    if current_user.present?
      if current_user.role.teller?
        return redirect_to my_business_categories_path
      end
      if current_user.role.supervisor? || current_user.role.admin?
        return redirect_to manager_dashboard_path
      end
    else
      redirect_to sign_in_path
    end
  end

  private
  def look_index
    @page_name = "home"

    user_data =
      if current_user.present?
      then DataFormer.new(current_user).data
      else nil
      end

    wares = ::Finance::TellerWare.where(:number.in => %w(117100 117200 121100 121200 121300 122100 122200 123010 123020 123030 330035 330040 330045 340005 341001 560003 650001 650002 650003 670001 670002)).map {|ware|
      DataFormer.new(ware)
        .url(:show_url)
        .data
    }

    @component_data = {
      manager_url: manager_dashboard_path,
      manager_sign_in_url: sign_in_path(role: "manager"),
      current_user: user_data,

      posts: EnterprisePositionLevel::Post.all.map {|x|
        DataFormer.new(x)
          .logic(:linked_levels)
          .data
      },

      result_wares: wares
    }
  end
end

class Manager::SupervisorTellersController < Manager::ApplicationController
  def index
    @page_name = "manager_supervisor_tellers"
#
    users = User.with_role(:teller).page(params[:page])
    data    = users.map do |x|
      DataFormer.new(x)
        .logic(:phone_number)
        .logic(:read_percent)
        .url(:supervisor_teller_show_url)
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

  def show
    user = User.find params[:id]

    @page_name = "manager_supervisor_teller_show"

    post = user.post

    if params[:pid].blank?
      parents_data = []
      data = post.root_business_categories.map {|x|
        DataFormer.new(x)
          .logic(:is_leaf)
          .logic(:read_percent_of_user, user)
          .data
      }
    else
      parent_bc = Bank::BusinessCategory.find params[:pid]
      if parent_bc.leaf?
        data = post.siblings_and_self_business_categories(parent_bc).map{ |x|
          if x.id.to_s == params[:pid]
            DataFormer.new(x).logic(:is_leaf).logic(:read_percent_of_user, user).data.merge(current: true)
          else
            DataFormer.new(x).logic(:is_leaf).logic(:read_percent_of_user, user).data
          end

        }
        parent_ids = parent_bc.parent_ids
      else
        data = post.children_business_categories(parent_bc).map {|x|
          DataFormer.new(x).logic(:is_leaf).logic(:read_percent_of_user, user).data
        }
        parent_ids = parent_bc.parent_ids + [parent_bc.id]
      end

      parents_data = parent_ids.map {|id|
        c = Bank::BusinessCategory.find id
        {
          category: DataFormer.new(c).data,
          siblings: post.siblings_and_self_business_categories(c).map {|x|
            DataFormer.new(x).data
          }
        }
      }

    end


    @component_data = {
      user: DataFormer.new(user).logic(:phone_number).logic(:post).url(:supervisor_teller_show_url).data,
      parents_data: parents_data,
      categories: data,
    }

  end

  private
  def pundit_manager
    authorize :manager_supervisor, "#{action_name}?"
  end
end

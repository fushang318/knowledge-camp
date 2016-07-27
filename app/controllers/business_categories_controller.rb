class BusinessCategoriesController < ApplicationController
  layout "new_version_base"

  def index
    @page_name = "front_business_categories"

    if params[:pid].blank?
      parents_data = []
      data = Bank::BusinessCategory.roots.map {|x|
        DataFormer.new(x).logic(:is_leaf).data
      }
      wares = []
    else
      parent_bc = Bank::BusinessCategory.find params[:pid]

      if parent_bc.leaf?
        data = parent_bc.siblings_and_self.map{ |x|
          if x.id.to_s == params[:pid]
            DataFormer.new(x).logic(:is_leaf).data.merge(current: true)
          else
            DataFormer.new(x).logic(:is_leaf).data
          end
        }
        parent_ids = parent_bc.parent_ids
      else
        data = parent_bc.children.map {|x|
          DataFormer.new(x).logic(:is_leaf).data
        }
        parent_ids = parent_bc.parent_ids + [parent_bc.id]
      end

      parents_data = parent_ids.map {|id|
        c = Bank::BusinessCategory.find id

        {
          category: DataFormer.new(c).data,
          siblings: c.siblings_and_self.map {|x|
            DataFormer.new(x).data
          }
        }
      }

      wares = parent_bc.all_wares_db.map do |ware|
        DataFormer.new(ware)
          .url(:show_url)
          .data
      end
    end

    @component_data = {
      parents_data: parents_data,
      categories: data,
      wares: wares
    }
  end

  def my
    @page_name = "post_business_categories"

    post = current_user.post

    if params[:pid].blank?
      parents_data = []
      data = post.root_business_categories.map {|x|
        DataFormer.new(x)
          .logic(:is_leaf)
          .logic(:read_percent_of_user, current_user)
          .data
      }
      wares = []
    else
      parent_bc = Bank::BusinessCategory.find params[:pid]
      if parent_bc.leaf?
        data = post.siblings_and_self_business_categories(parent_bc).map{ |x|
          if x.id.to_s == params[:pid]
            DataFormer.new(x).logic(:is_leaf).logic(:read_percent_of_user, current_user).data.merge(current: true)
          else
            DataFormer.new(x).logic(:is_leaf).logic(:read_percent_of_user, current_user).data
          end

        }
        parent_ids = parent_bc.parent_ids
      else
        data = post.children_business_categories(parent_bc).map {|x|
          DataFormer.new(x).logic(:is_leaf).logic(:read_percent_of_user, current_user).data
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

      wares = parent_bc.all_wares_of_post_db(post).map do |ware|
        DataFormer.new(ware)
          .url(:show_url)
          .logic(:read_percent_of_user, current_user)
          .data
      end
    end


    @component_data = {
      parents_data: parents_data,
      categories: data,
      wares: wares
    }
  end

  def show
    bc = Bank::BusinessCategory.find params[:id]
    parent_ids = bc.parent_ids
    parent_ids.shift

    videos = FilePartUpload::FileEntity.or({original: /#{bc.name}/}, {original: /#{bc.number}/}).map {|x|
      DataFormer.new(x).data
    }

    wares = Finance::TellerWare.or({number: /#{bc.number}/}, {name: /#{bc.name}/}).map {|x|
      DataFormer.new(x)
        .url(:show_url)
        .data
    }

    @page_name = "front_business_category_show"
    @component_data = {
      parents_data: parent_ids.map {|id|
        c = Bank::BusinessCategory.find id
        DataFormer.new(c).data
      },
      category: DataFormer.new(bc).data,
      videos: videos,
      teller_wares: wares
    }
  end
end

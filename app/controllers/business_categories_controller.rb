class BusinessCategoriesController < ApplicationController
  layout "new_version_base"

  def index
    @page_name = "front_business_categories"

    if params[:pid].blank?
      parents_data = []
      data = Bank::BusinessCategory.roots.map {|x|
        DataFormer.new(x).logic(:is_leaf).data
      }
    else
      parent_bc = Bank::BusinessCategory.find params[:pid]
      data = parent_bc.children.map {|x|
        DataFormer.new(x).logic(:is_leaf).data
      }
      parent_ids = parent_bc.parent_ids + [parent_bc.id]
      parents_data = parent_ids.map {|id|
        c = Bank::BusinessCategory.find id

        {
          category: DataFormer.new(c).data,
          siblings: c.siblings_and_self.map {|x|
            DataFormer.new(x).data
          }
        }
      }
    end

    @component_data = {
      parents_data: parents_data,
      categories: data
    }
  end

  def my
    @page_name = "post_business_categories"

    post = EnterprisePositionLevel::Post.all[0]
    p "~~~~~~~~~~~~~"
    p post.name

    if params[:pid].blank?
      parents_data = []
      data = post.root_business_categories.map {|x|
        DataFormer.new(x).logic(:is_leaf).data
      }
    else
      parent_bc = Bank::BusinessCategory.find params[:pid]
      data = post.children_business_categories(parent_bc).map {|x|
        DataFormer.new(x).logic(:is_leaf).data
      }
      parent_ids = parent_bc.parent_ids + [parent_bc.id]
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
      parents_data: parents_data,
      categories: data
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

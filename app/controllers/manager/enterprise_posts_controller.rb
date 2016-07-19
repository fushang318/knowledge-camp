class Manager::EnterprisePostsController < Manager::ApplicationController
  def index
    @page_name = "manager_enterprise_posts"

    posts = EnterprisePositionLevel::Post.all.map do |post|
      DataFormer.new(post)
        .url(:manager_edit_business_categories_url)
        .url(:delete_url)
        .url(:update_url)
        .data
    end

    @component_data = {
      posts: posts,
      create_url: manager_enterprise_posts_path
    }

    render "/mockup/page"
  end

  def create
    post = EnterprisePositionLevel::Post.new post_params
    save_model(post,"post") do |_post|
      DataFormer.new(_post)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def update
    post = EnterprisePositionLevel::Post.find params[:id]

    update_model(post, post_params, "post") do |_post|
      DataFormer.new(_post)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def destroy
    post = EnterprisePositionLevel::Post.find params[:id]
    post.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  def edit_business_categories
    post = EnterprisePositionLevel::Post.find params[:id]

    business_categories = Bank::BusinessCategory.all.map do |bc|
      DataFormer.new(bc).data
    end

    @page_name = "manager_edit_business_categories_enterprise_post"
    @component_data = {
      post: DataFormer.new(post).data,
      business_categories: business_categories,
      update_business_categories_url: update_business_categories_manager_enterprise_post_path(post)
    }
  end

  def update_business_categories
    post = EnterprisePositionLevel::Post.find params[:id]

    update_model(post, update_business_categories_post_params) do |c|
      DataFormer.new(c)
        .url(:manager_edit_business_categories_url)
        .url(:delete_url)
        .url(:update_url)
        .data
        .merge jump_url: manager_enterprise_posts_path
    end
  end


  private
  def post_params
    params.require(:post).permit(:name, :number)
  end

  def update_business_categories_post_params
    params.require(:post).permit(business_category_ids: [])
  end
end

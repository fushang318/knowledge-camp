class Manager::SimpleDocumentWaresController < Manager::ApplicationController
  def index
    @page_name = "manager_simple_document_wares"

    wares      = KcCourses::SimpleDocumentWare.all.page(params[:page])
    wares_data = wares.map do |ware|
      DataFormer.new(ware)
        .url(:manager_edit_base_info_url)
        .url(:manager_edit_business_categories_url)
        .data
    end

    @component_data = {
      new_simple_document_wares_url: new_manager_simple_document_ware_path,
      simple_document_wares: wares_data,
      paginate: {
        total_pages: wares.total_pages,
        current_page: wares.current_page,
        per_page: wares.limit_value
      }
    }
  end

  def new
    @page_name = "manager_new_simple_document_ware"
    @component_data = {
      create_simple_document_ware_url: manager_simple_document_wares_path
    }
  end

  def create
    ware = KcCourses::SimpleDocumentWare.new simple_document_ware_params
    ware.creator = current_user

    save_model(ware) do |c|
      DataFormer.new(c)
        .url(:manager_edit_base_info_url)
        .url(:manager_edit_business_categories_url)
        .data
        .merge jump_url: edit_business_categories_manager_simple_document_ware_path(c)
    end
  end

  def edit
    ware = KcCourses::SimpleDocumentWare.find params[:id]

    @page_name = "manager_edit_simple_document_ware"
    @component_data = {
      simple_document_ware: ware,
      update_base_info_url: manager_simple_document_ware_path(ware)
    }
  end

  def update
    ware = KcCourses::SimpleDocumentWare.find params[:id]

    update_model(ware, update_simple_document_ware_params) do |c|
      DataFormer.new(c)
        .url(:manager_edit_base_info_url)
        .url(:manager_edit_business_categories_url)
        .data
        .merge jump_url: manager_simple_document_wares_path
    end
  end

  def edit_business_categories
    ware = KcCourses::SimpleDocumentWare.find params[:id]

    business_categories = Bank::BusinessCategory.all.map do |bc|
      DataFormer.new(bc).data
    end

    @page_name = "manager_edit_business_categories_simple_document_ware"
    @component_data = {
      simple_document_ware: DataFormer.new(ware).data,
      business_categories: business_categories,
      update_business_categories_url: update_business_categories_manager_simple_document_ware_path(ware)
    }
  end

  def update_business_categories
    ware = KcCourses::SimpleDocumentWare.find params[:id]

    update_model(ware, update_business_categories_simple_document_ware_params) do |c|
      DataFormer.new(c)
        .url(:manager_edit_base_info_url)
        .url(:manager_edit_business_categories_url)
        .data
        .merge jump_url: manager_simple_document_wares_path
    end
  end

  private
  def simple_document_ware_params
    params.require(:simple_document_wares).permit(:name, :desc, :file_entity_id, business_category_ids: [])
  end

  def update_simple_document_ware_params
    params.require(:simple_document_wares).permit(:name, :desc)
  end

  def update_business_categories_simple_document_ware_params
    params.require(:simple_document_wares).permit(business_category_ids: [])
  end
end

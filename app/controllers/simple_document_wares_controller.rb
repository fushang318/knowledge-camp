class SimpleDocumentWaresController < ApplicationController
  layout "new_version_base"

  def show
    @page_name = 'simple_document_ware_show'

    ware = KcCourses::SimpleDocumentWare.find params[:id]

    ware_data = DataFormer.new(ware)
      .data

    @component_data = {
      ware: ware_data,
      in_business_categories: ware.in_business_categories?(current_user)
    }
    render "mockup/page", layout: "new_version_ware"
  end
end

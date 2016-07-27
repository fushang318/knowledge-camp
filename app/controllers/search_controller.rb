class SearchController < ApplicationController
  layout "new_version_base"

  def search
    @page_name = 'search_result'

    query = params[:query]

    # wares = ::Finance::TellerWare
    #   .or({name: /#{query}/}, {number: /#{query}/})

    wares = ::KcCourses::Ware
      .or({name: /#{query}/}, {number: /#{query}/})

    data = wares.map {|x|
      DataFormer.new(x)
        .url(:show_url)
        .data
    }

    @component_data = {
      query: query,
      wares: data
    }
  end
end

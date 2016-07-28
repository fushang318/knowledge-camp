class Manager::Finance::TellerWareMediaClipsController < ApplicationController
  before_filter :pundit_manager
  layout "new_version_manager"

  def index
    @page_name = "manager_finance_teller_ware_media_clips"
    clips = ::Finance::TellerWareMediaClip.order_by(id: :desc).page(params[:page]).per(15)

    if params[:search].present?
      query = params[:search]
      clips = clips.or({name: /#{query}/}, {desc: /#{query}/})
    end

    data = clips.map {|x|
      DataFormer.new(x)
        .logic(:file_info)
        .url(:update_url)
        .data
    }

    @component_data = {
      media_clips: data,
      paginate: DataFormer.paginate_data(clips),
      create_url: manager_finance_teller_ware_media_clips_path,
      search: params[:search] || ''
    }

    render "/mockup/page"
  end

  def create
    mc = ::Finance::TellerWareMediaClip.new clip_params
    save_model mc, 'clip' do |_clip|
      DataFormer.new(mc)
        .logic(:file_info)
        .url(:update_url)
        .data
    end
  end

  def update
    mc = ::Finance::TellerWareMediaClip.find params[:id]
    update_model mc, clip_params, 'clip' do |_clip|
      DataFormer.new(mc)
        .logic(:file_info)
        .url(:update_url)
        .data
    end
  end

  def search
    clips = ::Finance::TellerWareMediaClip.where(name: /#{params[:key]}/).limit(5)
    data = clips.map do |mc|
      DataFormer.new(mc)
        .logic(:file_info)
        .url(:update_url)
        .data
    end

    render json: data
  end

  def get_infos
    clips = ::Finance::TellerWareMediaClip.where(:cid.in => params[:cids])
    data = clips.map do |mc|
      DataFormer.new(mc)
        .logic(:file_info)
        .url(:update_url)
        .data
    end

    render json: data
  end

  private
  def clip_params
    params.require(:clip).permit(:name, :desc, :file_entity_id)
  end
end

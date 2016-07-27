module WareFormer
  extend ActiveSupport::Concern

  included do
    former "KcCourses::SimpleVideoWare" do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :business_categories, ->(instance){
        instance.business_categories.map do |bc|
          {
            id: bc.id.to_s,
            name: bc.name
          }
        end
      }
      field :kind, ->(instance) { "video" }
      field :time, ->(instance) {
        seconds = instance.file_entity.meta.try(:[], :video).try(:[], :total_duration).to_i
        "#{seconds/60}′#{seconds%60}″"
      }

      field :video_url, ->(instance){
        # TODO 目前转码的清晰度有问题，暂时永远播放源文件
        # instance.file_entity.transcode_url("超请") ||
        #   instance.file_entity.transcode_url("高请") ||
        #   instance.file_entity.transcode_url("标清") ||
        #   instance.file_entity.transcode_url("低清") ||
          instance.file_entity.url
      }

      logic :learned, ->(instance, user) {
        percent = instance.read_percent_of_user(user)
        learned = 'done' if percent == 100
        learned = 'half' if percent > 0 && percent < 100
        learned = 'no'   if percent == 0
        learned
      }

      logic :read_percent_of_user, ->(instance, user){
        instance.read_percent_of_user(user)
      }

      url :url, ->(instance){
        ""
      }

      url :update_url, ->(instance){
        manager_ware_path(instance)
      }

      url :move_down_url, ->(instance){
        move_down_manager_ware_path(instance)
      }

      url :move_up_url, ->(instance){
        move_up_manager_ware_path(instance)
      }

      url :delete_url, ->(instance){
        manager_ware_path(instance)
      }

      url :manager_edit_base_info_url, ->(instance){
        edit_manager_simple_video_ware_path(instance)
      }

      url :manager_edit_business_categories_url, ->(instance){
        edit_business_categories_manager_simple_video_ware_path(instance)
      }

      url :show_url, ->(instance) {
        simple_video_ware_path(instance)
      }

    end

    former "KcCourses::SimpleDocumentWare" do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :kind, ->(instance) { "document" }
      field :business_categories, ->(instance){
        instance.business_categories.map do |bc|
          {
            id: bc.id.to_s,
            name: bc.name
          }
        end
      }
      field :document_urls, ->(instance) {
        instance.file_entity ?
          instance.file_entity.transcode_urls("jpg") :
          []
      }

      logic :learned, ->(instance, user) {
        percent = instance.read_percent_of_user(user)
        learned = 'done' if percent == 100
        learned = 'half' if percent > 0 && percent < 100
        learned = 'no'   if percent == 0
        learned
      }

      logic :read_percent_of_user, ->(instance, user){
        instance.read_percent_of_user(user)
      }

      url :url, ->(instance){
        ware_path(instance.id.to_s)
      }

      url :update_url, ->(instance){
        manager_ware_path(instance)
      }

      url :move_down_url, ->(instance){
        move_down_manager_ware_path(instance)
      }

      url :move_up_url, ->(instance){
        move_up_manager_ware_path(instance)
      }

      url :delete_url, ->(instance){
        manager_ware_path(instance)
      }

      url :manager_edit_base_info_url, ->(instance){
        edit_manager_simple_document_ware_path(instance)
      }

      url :manager_edit_business_categories_url, ->(instance){
        edit_business_categories_manager_simple_document_ware_path(instance)
      }

      url :show_url, ->(instance) {
        simple_document_ware_path(instance)
      }
    end

    former "KcCourses::SimpleAudioWare" do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :kind, ->(instance) { "audio" }

      logic :learned, ->(instance, user) {
        percent = instance.read_percent_of_user(user)
        learned = 'done' if percent == 100
        learned = 'half' if percent > 0 && percent < 100
        learned = 'no'   if percent == 0
        learned
      }

      url :url, ->(instance){
        ware_path(instance.id.to_s)
      }

      url :update_url, ->(instance){
        manager_ware_path(instance)
      }

      url :move_down_url, ->(instance){
        move_down_manager_ware_path(instance)
      }

      url :move_up_url, ->(instance){
        move_up_manager_ware_path(instance)
      }

      url :delete_url, ->(instance){
        manager_ware_path(instance)
      }

    end

    former "KcCourses::Ware" do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      # field :kind, ->(instance) { "audio" }

      logic :learned, ->(instance, user) {
        percent = instance.read_percent_of_user(user)
        learned = 'done' if percent == 100
        learned = 'half' if percent > 0 && percent < 100
        learned = 'no'   if percent == 0
        learned
      }

      url :url, ->(instance){
        ware_path(instance.id.to_s)
      }

      url :update_url, ->(instance){
        manager_ware_path(instance)
      }

      url :move_down_url, ->(instance){
        move_down_manager_ware_path(instance)
      }

      url :move_up_url, ->(instance){
        move_up_manager_ware_path(instance)
      }

      url :delete_url, ->(instance){
        manager_ware_path(instance)
      }

    end


  end
end

module Finance::TellerWareFormer
  extend ActiveSupport::Concern

  included do

    former 'Finance::TellerWare' do
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
      field :number
      field :business_kind
      field :gtd_status
      field :editor_memo
      field :desc

      logic :actions, ->(instance) {
        instance.actions
      }

      logic :business_kind_str, ->(instance) {
        instance.business_kind_str
      }

      logic :relative_wares, ->(instance) {
        num = instance.number[0...3]
        Finance::TellerWare.where(number: /^#{num}/)
          .order(number: :asc)
          .select {|x|
            x.id != instance.id
          }
          .map {|x|
            DataFormer.new(x)
              .url(:show_url)
              .logic(:business_kind_str)
              .data
          }
      }

      url :show_url, ->(instance) {
        manager_finance_preview_path(number: instance.number)
      }

      url :preview_url, ->(instance) {
        manager_finance_preview_path(number: instance.number)
      }

      url :design_url, ->(instance) {
        design_manager_finance_teller_ware_path instance
      }

      url :update_url, ->(instance) {
        manager_finance_teller_ware_path instance
      }

      url :design_update_url, ->(instance) {
        design_update_manager_finance_teller_ware_path instance
      }

      url :manager_edit_business_categories_url, ->(instance) {
        edit_business_categories_manager_finance_teller_ware_path instance
      }
    end

  end
end

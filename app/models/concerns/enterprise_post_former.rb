module EnterprisePostFormer
  extend ActiveSupport::Concern

  included do

    former 'EnterprisePositionLevel::Post' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :number
      field :business_categories, ->(instance){
        instance.business_categories.map do |bc|
          {
            id: bc.id.to_s,
            name: bc.name
          }
        end
      }

      logic :linked_levels, ->(instance) {
        EnterprisePositionLevel::Level.all.map {|l|
          DataFormer.new(l).data
        }
      }

      url :delete_url, ->(instance){
        manager_enterprise_post_path(instance)
      }

      url :update_url, ->(instance){
        manager_enterprise_post_path(instance)
      }

      url :manager_edit_business_categories_url, ->(instance){
        edit_business_categories_manager_enterprise_post_path(instance)
      }

    end

  end
end

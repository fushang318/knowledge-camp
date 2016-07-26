module BusinessCategoryFormer
  extend ActiveSupport::Concern

  included do

    former 'Bank::BusinessCategory' do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :number
      field :parent_id, ->(instance) {
        parent_id = instance.parent_id
        parent_id ? parent_id.to_s : nil
      }
      field :parent_ids, ->(instance) {
        instance.parent_ids.map{|parent_id|parent_id.to_s}
      }

      url :delete_url, ->(instance){
        manager_business_category_path(instance)
      }

      url :update_url, ->(instance){
        manager_business_category_path(instance)
      }

      logic :is_leaf, ->(instance) {
        instance.children.count == 0
      }

      logic :read_percent_of_user, ->(instance, user) {
        instance.read_percent_of_user(user) || 0
      }

    end

  end
end

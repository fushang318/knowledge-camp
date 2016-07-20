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

      logic :business_category_tree, ->(instance, business_category) {
        if business_category.blank?
          bcs = instance.business_categories.map do |bc|
            bc.root
          end.uniq

          return {
            parents_data: [],
            categories: bcs.map {|bc| DataFormer.new(bc).data}
          }
        end

        all_business_categories = instance.business_categories.map do |bc|
          bc.ancestors_and_self
        end.flatten.uniq

        parents_data = all_business_categories.select do |bc|
          ids = business_category.parent_ids.map{|id|id.to_s}
          ids.include?(bc.id.to_s) || bc.id.to_s == business_category.id.to_s
        end.map do |category|
          id = category.parent_id.to_s
          siblings = all_business_categories.select do |bc|
            bc.parent_id.to_s == id
          end
          {
            category: DataFormer.new(category).data,
            siblings: siblings.map {|x| DataFormer.new(x).data }
          }
        end

        categories = all_business_categories.select do |bc|
          bc.parent_id.to_s == business_category.id.to_s
        end.map do |child|
          DataFormer.new(child).logic(:is_leaf).data
        end

        return {
          parents_data: parents_data,
          categories: categories
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

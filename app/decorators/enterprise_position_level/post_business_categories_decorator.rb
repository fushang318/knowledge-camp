module EnterprisePositionLevel
  class Post
    def root_business_categories
      self.business_categories.map do |bc|
        bc.root
      end.uniq
    end

    def children_business_categories(business_category)
      self.business_categories.map do |bc|
        bc.ancestors_and_self.select{|bc|bc.parent_id.to_s == business_category.id.to_s}
      end.flatten.uniq
    end

    def siblings_and_self_business_categories(business_category)
      self.business_categories.map do |bc|
        bc.ancestors_and_self.select{|bc|bc.parent_id.to_s == business_category.parent_id.to_s}
      end.flatten.uniq
    end

  end
end

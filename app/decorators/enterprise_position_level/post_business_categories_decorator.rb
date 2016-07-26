module EnterprisePositionLevel
  class Post
    include MongoidSimpleRedisCache::BaseMethods

    def siblings_and_self_business_categories(business_category)
      if business_category.parent_id.blank?
        self.root_business_categories
      else
        self.children_business_categories(business_category.parent)
      end
    end

    def children_business_categories_db(business_category)
      self.business_categories.map do |bc|
        bc.ancestors_and_self.select{|bc|bc.parent_id.to_s == business_category.id.to_s}
      end.flatten.uniq
    end

    def root_business_categories_db
      ids = self.business_categories.map do |bc|
        bc.parent_ids.first.to_s
      end.uniq
      Bank::BusinessCategory.where(:_id.in => ids).order(:number => :asc)
    end

  end
end

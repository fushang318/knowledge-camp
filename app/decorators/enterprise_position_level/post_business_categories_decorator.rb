module EnterprisePositionLevel
  class Post
    
    def siblings_and_self_business_categories(business_category)
      if business_category.parent_id.blank?
        self.root_business_categories
      else
        self.children_business_categories(business_category.parent)
      end
    end

  end
end

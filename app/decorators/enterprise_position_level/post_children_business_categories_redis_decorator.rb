module EnterprisePositionLevel
  class Post
    def children_business_categories(business_category)
      bcs = children_business_categories_redis(business_category)
      return bcs if !bcs.nil?

      bcs = children_business_categories_db(business_category)
      ids = bcs.map{|bc|bc.id.to_s}
      set_redis_post_id_business_category_id_children_business_category_ids(business_category.id.to_s, ids)

      return bcs
    end


    def children_business_categories_db(business_category)
      self.business_categories.map do |bc|
        bc.ancestors_and_self.select{|bc|bc.parent_id.to_s == business_category.id.to_s}
      end.flatten.uniq
    end

    def children_business_categories_redis(business_category)
      key = "post_#{self.id.to_s}_business_category_#{business_category.id.to_s}_children_business_category_ids"
      ids = RedisClient.get_data(key)
      return nil if ids.nil?
      Bank::BusinessCategory.where(:_id.in => ids).order(:number => :asc)
    end

    after_save :set_redis_post_id_business_category_id_children_business_category_ids_callback
    def set_redis_post_id_business_category_id_children_business_category_ids_callback
      if self.changed.include?("business_category_ids")
        set_redis_post_id_business_category_id_children_business_category_ids_all
      end
      return true
    end

    def set_redis_post_id_business_category_id_children_business_category_ids_all
      all_ids = self.business_categories.map do |bc|
        ids = bc.parent_ids.map{|id|id.to_s}
        ids.push bc.id.to_s
        ids
      end.flatten.uniq
      bc_info_array = Bank::BusinessCategory.where(:_id.in => all_ids).as_json(only: ["_id","parent_id"])

      key_parent_id_value_ids_hash = {}
      bc_info_array.each do |info|
        id = info["_id"].to_s
        parent_id = info["parent_id"].nil? ? nil : info["parent_id"].to_s
        key_parent_id_value_ids_hash[parent_id] ||= []
        key_parent_id_value_ids_hash[parent_id].push id
      end

      key_parent_id_value_ids_hash.each do |parent_id, ids|
        set_redis_post_id_business_category_id_children_business_category_ids(parent_id, ids)
      end

    end

    def set_redis_post_id_business_category_id_children_business_category_ids(parent_id, ids)
      key = "post_#{self.id.to_s}_business_category_#{parent_id}_children_business_category_ids"
      RedisClient.set_data(key, ids)
    end

  end
end

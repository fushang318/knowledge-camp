module EnterprisePositionLevel
  class Post
    def root_business_categories
      bcs = self.root_business_categories_redis
      return bcs if !bcs.nil?

      bcs = self.root_business_categories_db
      ids = bcs.map{|bc|bc.id.to_s}
      set_redis_cache_post_id_root_business_category_ids(ids)

      return bcs
    end

    def root_business_categories_db
      ids = self.business_categories.map do |bc|
        bc.parent_ids.first.to_s
      end.uniq
      Bank::BusinessCategory.where(:_id.in => ids).order(:number => :asc)
    end

    def root_business_categories_redis
      key = "post_#{self.id.to_s}_root_business_category_ids"
      ids = RedisClient.get_data(key)
      return nil if ids.nil?
      Bank::BusinessCategory.where(:_id.in => ids).order(:number => :asc)
    end

    after_save :set_redis_cache_post_id_root_business_category_ids_callback
    def set_redis_cache_post_id_root_business_category_ids_callback
      if self.changed.include?("business_category_ids")
        ids = self.root_business_categories_db.map{|bc|bc.id.to_s}
        set_redis_cache_post_id_root_business_category_ids(ids)
      end
      return true
    end

    def set_redis_cache_post_id_root_business_category_ids(ids)
      key = "post_#{self.id.to_s}_root_business_category_ids"
      RedisClient.set_data(key, ids)
    end


  end
end

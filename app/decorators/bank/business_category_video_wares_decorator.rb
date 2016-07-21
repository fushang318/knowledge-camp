module Bank
  class BusinessCategory
    include MongoidSimpleRedisCache::BaseMethods

    def simple_video_wares_of_post_db(post)
      if self.leaf?
        return KcCourses::SimpleVideoWare.where(:business_category_ids.in => [self.id.to_s]).to_a
      end

      bcs = post.children_business_categories(self)
      return [] if bcs.blank?
      bcs.map do |bc|
        bc.simple_video_wares_of_post_db(post)
      end.inject do |wares1, wares2|
        wares1 = wares1 & wares2
      end
    end

  end
end

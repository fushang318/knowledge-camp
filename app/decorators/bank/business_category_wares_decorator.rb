module Bank
  class BusinessCategory
    include MongoidSimpleRedisCache::BaseMethods

    def simple_video_wares_db(post)
      wares_db(KcCourses::SimpleVideoWare)
    end

    def simple_document_wares_db(post)
      wares_db(KcCourses::SimpleDocumentWare)
    end

    def finance_teller_wares_db(post)
      wares_db(Finance::TellerWare)
    end

    def simple_video_wares_of_post_db(post)
      wares_of_post_db(post, KcCourses::SimpleVideoWare)
    end

    def simple_document_wares_of_post_db(post)
      wares_of_post_db(post, KcCourses::SimpleDocumentWare)
    end

    def finance_teller_wares_of_post_db(post)
      wares_of_post_db(post, Finance::TellerWare)
    end

    def wares_of_post_db(post, ware_type_class)
      if self.leaf?
        return ware_type_class.where(:business_category_ids.in => [self.id.to_s]).to_a
      end

      bcs = post.children_business_categories(self)
      return [] if bcs.blank?

      bcs.map do |bc|
        bc.wares_of_post_db(post, ware_type_class)
      end.inject do |wares1, wares2|
        wares1 = wares1 & wares2
      end
    end

    def wares_db(ware_type_class)
      if self.leaf?
        return ware_type_class.where(:business_category_ids.in => [self.id.to_s]).to_a
      end

      self.children.map do |bc|
        bc.wares_db(ware_type_class)
      end.inject do |wares1, wares2|
        wares1 = wares1 & wares2
      end
    end

  end
end

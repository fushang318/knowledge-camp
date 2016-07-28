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

    def all_wares_of_post_db(post)
      wares_of_post_db(post, KcCourses::Ware)
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
      post_business_category_ids = post.business_category_ids.map{|bid|bid.to_s}
      leaf_business_category_ids = self.leaves.map{|l|l.id.to_s}
      ids = post_business_category_ids & leaf_business_category_ids
      ware_type_class.where(:business_category_ids.all => ids).to_a
    end

    def all_wares_db
      wares_db(KcCourses::Ware)
    end

    def wares_db(ware_type_class)
      leaf_business_category_ids = self.leaves.map{|l|l.id.to_s}
      ware_type_class.where(:business_category_ids.all => leaf_business_category_ids).to_a
    end

  end
end

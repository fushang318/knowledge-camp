MongoidSimpleRedisCache.config do

  # set_skip_redis true

  # post.root_business_categories
  vector_cache name: :root_business_categories,
               model: Bank::BusinessCategory,
               caller: EnterprisePositionLevel::Post do

    rules do

      after_save EnterprisePositionLevel::Post do |post|
        if post.changed.include?("business_category_ids")
          refresh_cache(post)
        end
      end

    end

  end

  # post.children_business_categories(business_category)
  vector_cache name: :children_business_categories,
               params: [:business_category],
               model: Bank::BusinessCategory,
               caller: EnterprisePositionLevel::Post do

    rules do

      after_save EnterprisePositionLevel::Post do |post|
        if post.changed.include?("business_category_ids")
          all_ids = post.business_categories.map do |bc|
            ids = bc.parent_ids.map{|id|id.to_s}
            ids.push bc.id.to_s
            ids
          end.flatten.uniq
          bc_info_array = Bank::BusinessCategory.where(:_id.in => all_ids).as_json(only: ["_id","parent_id"])

          key_parent_id_value_ids_hash = {}
          bc_info_array.each do |info|
            id = info["_id"].to_s
            parent_id = info["parent_id"].nil? ? nil : info["parent_id"].to_s
            next if parent_id.nil?
            key_parent_id_value_ids_hash[parent_id] ||= []
            key_parent_id_value_ids_hash[parent_id].push id
          end

          key_parent_id_value_ids_hash.each do |parent_id, ids|
            custom_refresh_cache(
              post,
              {class: Bank::BusinessCategory, id: parent_id},
              ids)
          end


        end
      end

    end

  end

  # category.posts_count_of_user_db(user)
  # value_cache :name   => :posts_count_of_user,
  #             :params => [:user],
  #             :value_type => Fixnum,
  #             :caller => Category do
  #
  #   rules do
  #
  #     after_save Post do |post|
  #       post.categories.each do |category|
  #         refresh_cache(category, post.user)
  #       end
  #     end
  #
  #   end
  #
  # end

  # category.posts
  # vector_cache :name   => :posts,
  #              :params => [],
  #              :caller => Category,
  #              :model  => Post do
  #
  #   rules do
  #
  #     after_save Post do |post|
  #       post.categories.each do |category|
  #         refresh_cache(category, post.user)
  #       end
  #     end
  #
  #   end
  #
  # end

  # category.posts_count
  # value_cache :name   => :posts_count,
  #             :params => [],
  #             :value_type => Fixnum,
  #             :caller => Category do
  #
  #   rules do
  #
  #     after_save Post do |post|
  #       post.categories.each do |category|
  #         refresh_cache(category, post.user)
  #       end
  #     end
  #
  #   end
  #
  # end

end

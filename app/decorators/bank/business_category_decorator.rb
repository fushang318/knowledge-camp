Bank::BusinessCategory.class_eval do
  def wares
    KcCourses::Ware.where(:business_category_ids.in => [self.id.to_s])
  end

  # # user 已经学习了该业务类别下所有课件的百分比
  # def read_percent_of_user(user)
  #   raise if user.blank?
  #   # 是否叶子节点
  #   if leaf?
  #     # 课件为空则返回nil
  #     return if wares.blank?
  #     percent_sum = wares.sum{ |ware| ware.read_percent_of_user(user) }
  #     percent_sum / wares.count
  #   else
  #     # 统计所有子节点
  #     percents = user.post.children_business_categories(self).map{ |child| child.read_percent_of_user(user) }.compact
  #     return nil if percents.blank?
  #     percents.sum / percents.count
  #   end
  # end

  # user 已经学习了该业务类别下所有课件的百分比
  def read_percent_of_user(user)
    raise if user.blank?
    return nil if user.post.blank?


    post_business_category_ids = user.post.business_category_ids.map{|bid|bid.to_s}

    if self.leaf?
      leaf_business_category_ids = [self.id.to_s]
    else
      leaf_business_category_ids = self.leaves.map{|l|l.id.to_s}
    end

    ids = post_business_category_ids & leaf_business_category_ids

    ware_ids = KcCourses::Ware
      .where(:business_category_ids.in => ids)
      .only(:id).map{|w|w.id.to_s}

    return nil if ware_ids.blank?
    user.read_percent_in_wares(ware_ids)
  end

  # user 是否已经完成整个 ware 的学习（read_percent 是 100 时，表示完成学习）
  def has_read_by_user?(user)
    read_percent_of_user(user) == 100
  end

end

Bank::BusinessCategory.class_eval do
  has_and_belongs_to_many :wares, class_name: "KcCourses::Ware", inverse_of: :business_categories

  #def set_read_percent_by_user(user, read_percent)
    #raise "传入错误的百分比" if read_percent > 100 or read_percent < 0
    #return true if read_percent_of_user(user) >= read_percent
    #ware_reading = self.ware_readings.where(:creator_id => user.id.to_s).first
    #if ware_reading.blank?
      #self.ware_readings.create(:creator => user, :read_percent => read_percent)
    #else
      #ware_reading.update(:read_percent => read_percent)
    #end
  #end

  # user 已经学习了该业务类别下所有课件的百分比
  def read_percent_of_user(user)
    raise if user.blank?
    # 是否叶子节点
    if leaf?
      # 课件为空则返回nil
      return if wares.blank?
      percent_sum = wares.sum{ |ware| ware.read_percent_of_user(user) }
      percent_sum / wares.count
    else
      # 统计所有子节点
      percents = children.map{ |child| child.read_percent_of_user(user) }.compact
      return nil if percents.blank?
      percents.sum / percents.count
    end
  end

  # user 是否已经完成整个 ware 的学习（read_percent 是 100 时，表示完成学习）
  def has_read_by_user?(user)
    read_percent_of_user(user) == 100
  end

end

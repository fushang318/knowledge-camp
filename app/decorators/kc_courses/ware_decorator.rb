KcCourses::Ware.class_eval do
  has_many :questions, class_name: "QuestionMod::Question", as: :targetable
  has_many :notes,     class_name: "NoteMod::Note",         as: :targetable

  has_and_belongs_to_many :business_categories, class_name: "Bank::BusinessCategory", inverse_of: nil

  def in_business_categories?(user)
    raise "用户不能为空" if user.nil?
    categories = user.post.try(:business_categories).to_a
    (categories & business_categories.to_a).any?
  end
end

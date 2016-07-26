KcCourses::Ware.class_eval do
  has_many :questions, class_name: "QuestionMod::Question", as: :targetable
  has_many :notes,     class_name: "NoteMod::Note",         as: :targetable

  has_and_belongs_to_many :business_categories, class_name: "Bank::BusinessCategory", inverse_of: nil
end

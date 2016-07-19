module EnterprisePositionLevel
  class Post
    has_and_belongs_to_many :business_categories, class_name: "Bank::BusinessCategory", inverse_of: nil
  end
end

FactoryGirl.define do
  factory :post, class: EnterprisePositionLevel::Post do
    sequence :name do |n|
      "#{n}岗位"
    end
    sequence :number do |n|
      "#{n}"
    end
  end
end

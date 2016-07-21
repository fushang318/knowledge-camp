FactoryGirl.define do
  factory :business_category, class: Bank::BusinessCategory do
    sequence :name do |n|
      "#{n}业务分类"
    end
    sequence :number do |n|
      "#{n}"
    end
  end
end

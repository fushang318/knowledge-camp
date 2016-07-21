FactoryGirl.define do
  factory :ware, class: KcCourses::Ware do
    name "课件1"
    desc "课件1 描述"
    association :creator, factory: :user
  end
end

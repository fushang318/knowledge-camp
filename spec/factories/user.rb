FactoryGirl.define do
  factory :user do
    sequence(:name){|n| "user#{n}"}
    sequence(:email){|n| "user#{n}@example.com"}
    sequence(:phone_number){|n| "1333333#{"%04d" % n}"}
    password "123456"
  end

  factory :user_course_creator, class: User do
    sequence(:name){|n| "course_creator#{n}"}
    sequence(:email){|n| "course_creator#{n}@example.com"}
    role "admin"
    password "123456"
  end
end

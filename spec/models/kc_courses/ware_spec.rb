require 'rails_helper'

RSpec.describe KcCourses::Ware, type: :model do
  before do
    @ware = create(:ware)
  end

  it "关系" do
    expect(@ware.respond_to?(:questions)).to be true
    expect(@ware.respond_to?(:notes)).to be true
    expect(@ware.respond_to?(:business_categories)).to be true
  end

  describe "方法" do
    it "in_business_categories?" do
      expect{@ware.in_business_categories?(nil)}.to raise_error("用户不能为空")

      bs = create(:business_category)
      @ware.business_categories << bs
      post = create(:post)
      post.business_categories << bs
      user = create(:user, post: post)

      expect(@ware.in_business_categories?(user)).to be true
    end
  end
end

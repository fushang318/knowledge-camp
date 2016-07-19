require 'rails_helper'

RSpec.describe EnterprisePositionLevel::Post, type: :model do
  it "关系" do
    @post = create(:post)
    expect(@post.respond_to?(:business_categories)).to be true
  end
end

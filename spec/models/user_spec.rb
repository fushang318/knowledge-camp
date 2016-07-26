require 'rails_helper'

RSpec.describe User, type: :model do
  it "teller?" do
    # 默认为柜员
    expect(build(:user).teller?).to be true

    expect(create(:user, role: :supervisor).teller?).to be false
    expect(create(:user, role: :admin).teller?).to be false
  end

  describe "手机号验证" do
    describe "柜员" do
      it "手机号不能为空" do
        expect(build(:user, phone_number: nil)).to_not be_valid
      end

      it "手机号不能重复" do
        create(:user, phone_number: "13333339999")
        expect(build(:user, phone_number: "13333339999")).to_not be_valid
      end
    end

    describe "督导员" do
      it "手机号可以为空" do
        expect(build(:user, role: :supervisor, phone_number: nil)).to be_valid
      end
    end

    describe "管理员" do
      it "手机号可以为空" do
        expect(build(:user, role: :admin, phone_number: nil)).to be_valid
      end
    end
  end
end

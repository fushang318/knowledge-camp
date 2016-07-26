require 'rails_helper'

RSpec.describe Bank::BusinessCategory, type: :model do
  it "wares" do
    @business_category = create(:business_category)
    expect(@business_category.respond_to?(:wares)).to be true
  end

  it "has_read_by_user?" do
    @business_category = create(:business_category)
    @ware = create(:ware)
    @user = create(:user)
    @ware.business_categories << @business_category

    expect(@business_category.has_read_by_user?(@user)).to be false

    @ware.set_read_percent_by_user(@user, 100)
    expect(@business_category.has_read_by_user?(@user)).to be true
  end

  describe "read_percent_of_user" do
    it "nil user 会raise" do
      @business_category = create(:business_category)
      expect{@business_category.read_percent_of_user(nil)}.to raise_error(RuntimeError)
    end

    describe "@user" do
      before do
        @user = create(:user)
      end

      it "没有课件" do
        @business_category = create(:business_category)
        expect(@business_category.read_percent_of_user(@user)).to be_nil
      end

      describe "复杂结构" do
        # 1
        # |-2--w1 20%
        # |-3--w2 30%
        # |  |-w3 40%
        # |
        # |-4--5  无课件
        # |  |-6--w4 50%
        # |  |  |-w5 60%
        # |  |
        # |  |-7--w6 70%
        # |     |-w7 80%
        # |     |-w8 无数据
        # |-8 无课件
        before do
          (1..8).each do |i|
            eval("@c#{i} = create(:business_category)")
            eval("@w#{i} = create(:ware)")
          end

          @c1.children << @c2
          @c1.children << @c3
          @c1.children << @c4

          @c4.children << @c5
          @c4.children << @c6
          @c4.children << @c7

          @w1.business_categories << @c2

          @w2.business_categories << @c3
          @w3.business_categories << @c3

          @w4.business_categories << @c6
          @w5.business_categories << @c6

          @w6.business_categories << @c7
          @w7.business_categories << @c7
          @w8.business_categories << @c7
        end

        it "无学习记录返回0" do
          [1, 2, 3, 4, 6, 7].each do |i|
            expect(eval("@c#{i}").read_percent_of_user(@user)).to eq 0
          end
        end

        it "学习记录均为100时候，返回100" do
          (1..8).each do |i|
            eval("@w#{i}").set_read_percent_by_user(@user, 100)
          end
          [1, 2, 3, 4, 6, 7].each do |i|
            expect(eval("@c#{i}").read_percent_of_user(@user)).to eq 100
          end
        end

        it "复杂结构" do
          @w1.set_read_percent_by_user @user, 20
          @w2.set_read_percent_by_user @user, 30
          @w3.set_read_percent_by_user @user, 40
          @w4.set_read_percent_by_user @user, 50
          @w5.set_read_percent_by_user @user, 60
          @w6.set_read_percent_by_user @user, 70
          @w7.set_read_percent_by_user @user, 80

          expect(@c2.read_percent_of_user(@user)).to eq 20

          expect(@c3.read_percent_of_user(@user)).to eq 35

          expect(@c5.read_percent_of_user(@user)).to be_nil
          expect(@c6.read_percent_of_user(@user)).to eq 55
          expect(@c7.read_percent_of_user(@user)).to eq 50

          expect(@c8.read_percent_of_user(@user)).to be_nil

          # 因为返回的是整数，往下处理，所以此处为52非52.5
          expect(@c4.read_percent_of_user(@user)).to eq 52

          # 35.66 ~= 35
          expect(@c1.read_percent_of_user(@user)).to eq 35
        end
      end
    end
  end
end

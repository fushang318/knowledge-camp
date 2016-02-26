require 'rails_helper'

RSpec.describe CmsConfig, type: :model do
  it "attributes" do
    @cms_config = create(:cms_config)
    expect(@cms_config.respond_to?(:name)).to eq true
    expect(@cms_config.respond_to?(:value)).to eq true
  end

  it 'validates' do
    expect(build(:cms_config, name: nil)).not_to be_valid
  end

  it '指定显示在导航下拉（nav dropdown）中的课程分类' do
    @subjects = []
    @subjects << create(:course_subject)
    @subjects << create(:course_subject)
    @subjects.each do |subject|
      create(:cms_config, name: 'show_course_subject_in_nav_dropdown', value: subject.id)
    end

    expect(
      KcCourses::CourseSubject.find(CmsConfig.where(name: 'show_course_subject_in_nav_dropdown').map(&:value))
    ).to eq @subjects
  end

  it '指定显示在导航中的课程分类' do
    @subjects = []
    @subjects << create(:course_subject)
    @subjects << create(:course_subject)
    @subjects.each do |subject|
      create(:cms_config, name: 'show_course_subject_in_nav_item', value: subject.id)
    end

    expect(
      KcCourses::CourseSubject.find(CmsConfig.where(name: 'show_course_subject_in_nav_item').map(&:value))
    ).to eq @subjects
  end
end

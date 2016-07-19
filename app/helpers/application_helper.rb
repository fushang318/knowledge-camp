module ApplicationHelper
  def manager_sidebar_scenes
    [
      {
        name: '课件管理',
        funcs: [
          {
            name: '视频课件',
            url: manager_simple_video_wares_path,
            icon: 'video'
          },
          {
            name: '文档课件',
            url: manager_simple_document_wares_path,
            icon: 'file'
          },
        ]
      },
      {
        name: '课程编排',
        funcs: [
          {
            name: '开课管理',
            url: manager_courses_path,
            icon: 'newspaper'
          },
          {
            name: '分类管理',
            url: manager_course_subjects_path,
            icon: 'tag'
          },
        ]
      },
      {
        name: '课程维护',
        funcs: [
          {
            name: '课程发布',
            url: manager_published_courses_path,
            icon: 'send'
          }
        ]
      },
      {
        name: '培训策略管理',
        funcs: [
          {
            name: '业务类别设置',
            url: manager_business_categories_path,
            icon: 'sitemap'
          },
          {
            name: '岗位设置',
            url: manager_enterprise_posts_path,
            icon: 'sitemap'
          },
          {
            name: '级别设置',
            url: manager_enterprise_levels_path,
            icon: 'sitemap'
          }
        ]
      },

      {
        name: '银行领域知识',
        funcs: [
          {
            name: '前端柜员操作',
            url: manager_finance_teller_wares_path,
            icon: 'rmb'
          },
          {
            name: '模拟屏幕预览',
            url: screens_manager_finance_teller_wares_path,
            icon: 'desktop'
          },
          {
            name: '关联交易数据',
            url: trades_manager_finance_teller_wares_path,
            icon: 'rmb'
          },
          {
            name: '前端课件媒体资源',
            url: manager_finance_teller_ware_media_clips_path,
            icon: 'video'
          }
        ]
      },
    ]
  end
end

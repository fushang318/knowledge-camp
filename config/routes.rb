def routes_draw(routes_name)
  instance_eval(File.read(Rails.root.join('config', "routes_#{routes_name}.rb")))
end

routes_draw :mockup

Rails.application.routes.draw do
  root 'index#index'

  get '/search/:query' => 'search#search', as: :search

  devise_for :users, :skip => :all

  # 文件上传
  mount FilePartUpload::Engine => "/e/file_part_upload", :as => :e_file_part_upload
  # 课程功能
  KcCourses::Routing.mount '/e/kc_courses', as: :e_courses

  # --------------------
  # kc mobile 2016
  get "/user_dashboard"              => "user_dashboard#index",        as: :user_dashboard
  get "/user_dashboard/my_courses"   => "user_dashboard#my_courses",   as: :user_dashboard_my_courses
  get "/user_dashboard/my_notes"     => "user_dashboard#my_notes",     as: :user_dashboard_my_notes
  get "/user_dashboard/my_questions" => "user_dashboard#my_questions", as: :user_dashboard_my_questions
  resources :subjects
  resources :courses do
    get "/wares/:ware_id" => "courses#ware", as: :ware
  end

  resources :questions do
    get :ware, on: :collection
  end

  resources :notes do
    get :ware, on: :collection
  end

  devise_scope :user do
    get    "/sign_in"      => "sessions#new"
    post   "/api/sign_in"  => "sessions#create"
    delete "/api/sign_out" => "sessions#destroy"

    get    "/sign_up"      => "registrations#new"
    post   "/api/sign_up"  => "registrations#create"
  end

  resources :business_categories

  scope :path => "/manager", module: 'manager', as: :manager do
    get "dashboard" => "dashboard#index"

    resources :courses, shallow: true do
      get :organize, on: :member
      resources :chapters, shallow: true do
        put :move_up,   on: :member
        put :move_down, on: :member
        resources :wares do
          put :move_up,   on: :member
          put :move_down, on: :member
        end
      end
    end

    resources :course_subjects

    resources :published_courses do
      post   :publish, on: :collection
      delete :recall,  on: :collection
    end

    # 视频课件管理
    resources :simple_video_wares do
      get  :edit_business_categories,   on: :member
      put :update_business_categories, on: :member
    end

    resources :business_categories
    resources :enterprise_posts do
      get  :edit_business_categories,   on: :member
      put :update_business_categories, on: :member
    end
    resources :enterprise_levels

    scope :path => '/finance', module: 'finance', as: :finance do
      resources :teller_wares do
        get :screens, on: :collection
        get :trades, on: :collection

        get :trade, on: :collection

        get :hmdm, on: :collection
        get :edit_screen_sample, on: :collection
        put :update_screen_sample, on: :collection

        get :design, on: :member
        put :design_update, on: :member
      end
      get '/teller_wares/:number/preview' => "teller_wares#preview", as: :preview

      resources :teller_ware_media_clips do
        get :search, on: :collection
        get :get_infos, on: :collection
      end
    end

  end
end

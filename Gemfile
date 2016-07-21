# coding: utf-8

ruby '2.2.5'

source "https://ruby.taobao.org"

gem "rails", "4.2.3"
gem 'sass-rails', '~> 5.0'
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "turbolinks"
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'therubyracer', platforms: :ruby

group :development do
  # 去除测试环境 assets提示
  gem 'quiet_assets'
  gem 'pry-rails'
end

group :development, :test do
  gem "spring"
  gem "pry"
  gem "pry-byebug"
end

group :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0'
  gem "database_cleaner", "~> 1.2.0"
  gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'headless'
  gem 'selenium-webdriver'
end

# -------------

gem "figaro", "~> 1.1.1"
gem "devise", "3.5.2"
gem "kaminari", "~> 0.15.1"
gem "haml"
gem "mongoid", "~> 4.0.0"
gem "bson_ext"
gem "unicorn"
gem "streamio-ffmpeg"
gem 'redis', '~>3.2'
# -------------
gem "mina", "0.3.7"

# --------------------------------------

# 全文搜索
gem "elasticsearch-simple",
    github: "mindpin/elasticsearch-simple",
    ref: '9697be2'

# 支持分段上传的文件持久化
gem 'file-part-upload',
    github: "mindpin/file-part-upload",
    ref: "6164fd3"

# -----金融学院相关
gem 'kc_courses',
    github: 'mindpin/kc_courses',
    ref: "139166f"

gem 'bank',
    github: "mindpin/bank",
    ref: "b749551"

gem 'enterprise_position_level',
    github: "mindpin/enterprise_position_level",
    ref: "541bf8a"

gem 'question_mod',
    github: "fushang318/question_mod",
    ref: "dc5c9ea"

gem 'mongoid-simple-redis-cache',
    github: "mindpin/mongoid-simple-redis-cache",
    ref: "f5fd2df"

# gem 'mongoid-simple-redis-cache', path: "/home/mindpin/mongoid-simple-redis-cache"

# ----------------------------------

gem 'sprockets', '3.4.0'
gem 'sprockets-rails', '2.3.3'

gem 'react-rails', '1.2.0'
gem 'sprockets-coffee-react', '3.0.1'

# 控制台
gem 'web-console', '~> 2.0'

# 去除静态资源指纹
gem 'non-stupid-digest-assets'

# 通过 rails assets 服务加载前端包
source 'https://rails-assets.org'
gem 'rails-assets-semantic'

#http://medialize.github.io/URI.js/
gem 'rails-assets-URIjs'
# http://facebook.github.io/immutable-js/
gem 'rails-assets-immutable'
# https://github.com/Olical/EventEmitter/blob/master/docs/guide.md
gem 'rails-assets-eventEmitter'

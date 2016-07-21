REDIS_INSTANCE = Redis.new(
  :host => ENV['redis_host'],
  :port => ENV['redis_port'],
  :db => ENV['redis_db'])

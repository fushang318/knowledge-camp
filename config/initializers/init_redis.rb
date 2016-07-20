config = YAML.load(IO.read(Rails.root.join("config/redis.yml")))[Rails.env]
REDIS_INSTANCE = Redis.new(:host => config["host"], :port => config["port"], :db => config["db"])

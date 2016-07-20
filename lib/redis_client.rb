class RedisClient
  @@skip_redis = false
  def self.skip_redis(&block)
    @@skip_redis = true
    block.call
    @@skip_redis = false
  end

  # array or hash
  def self.get_data(key)
    return nil if @@skip_redis
    value = REDIS_INSTANCE.get(key)
    return nil if value.nil?
    JSON.parse(value)
  end

  # array or hash
  def self.set_data(key, value)
    return nil if @@skip_redis
    data = JSON.generate(value)
    REDIS_INSTANCE.set(key, data)
  end

end

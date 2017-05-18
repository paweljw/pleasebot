require 'singleton'
require 'redis'

class RedisService
  include Singleton

  def initialize
    @redis = Redis.new(url: Pleasebot.redis_url)
    @redlock = Redlock::Client.new([@redis])
  end

  def exist?(pull_request)
    @redis.get(pull_request.id)
  end

  def with_lock(id)
    @redlock.lock("#{id}-lock", 2000) { |locked| yield if locked && block_given? }
  end

  def mark_done(pull_request)
    @redis.set(pull_request.id, true)
  end
end

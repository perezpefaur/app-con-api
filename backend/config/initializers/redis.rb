require 'redis'

Redis.current = Redis.new(
    #host:  ENV.fetch("REDIS_HOST"),
    url:  ENV.fetch("REDIS_URL")
)
class CacheWrapper
	def self.set_with_expiry(key, expiry_time_in_seconds, data)
		REDIS.setex(key, expiry_time_in_seconds, data)
	end

	def self.fetch(key)
		REDIS.get(key)
	end
end
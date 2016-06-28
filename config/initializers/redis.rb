uri = ENV["REDISTOGO_URL"] || "redis://0.0.0.0:3000/"
REDIS = Redis.new(:url => uri)
require "cloudinary"

Cloudinary.config_from_url("cloudinary://#{ENV["CLOUD_KEY"]}:#{ENV["CLOUD_SECRET"]}@#{ENV["CLOUD_NAME"]}")

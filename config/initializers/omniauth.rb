Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :yahoo_auth, "dj0yJmk9ZGdpRUlZYXJPR3E0JmQ9WVdrOVJXVjJXVkI2Tm5NbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PThj", "6d7837d0e0bf38aad9a92fb903a56331d71c5042"
  provider :yahoo_auth, ENV['YAHOO_CLIENT_ID'], ENV['YAHOO_CLIENT_SECRET']
end

class User < ActiveRecord::Base
  unloadable
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  include MuckUsers::Models::Sharer
  include MuckShares::Models::Sharer
  include MuckProfiles::Models::User
  MuckActivities::Models::ActivityConsumer

  def feed_to
    self
  end
  
end
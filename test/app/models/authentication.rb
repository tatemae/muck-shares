class Authentication < ActiveRecord::Base
  validates_presence_of :provider
  validates_presence_of :uid
  include MuckAuth::Models::MuckAuthentication
end
class Share < ActiveRecord::Base
  unloadable
  include MuckShares::Models::MuckShare
end
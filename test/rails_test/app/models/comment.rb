class Comment < ActiveRecord::Base
  acts_as_muck_comment
  MuckActivities::Models::ActivitySource
end
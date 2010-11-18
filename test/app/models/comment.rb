class Comment < ActiveRecord::Base
  include MuckComments::Models::MuckComment
  include MuckActivities::Models::MuckActivitySource
end
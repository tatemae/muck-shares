require 'muck-comments'
require 'muck-activities'
# include MuckShares::Models::MuckShare
module MuckShares
  module Models
    module MuckShare
      extend ActiveSupport::Concern
      
      included do
        belongs_to :shared_by, :polymorphic => true
        validates_presence_of :uri
        validates_presence_of :title
          
        scope :by_newest, :order => "shares.created_at DESC"
        scope :by_oldest, :order => "shares.created_at ASC"
        scope :newer_than, lambda { |*args| where("shares.created_at > ?", args.first || DateTime.now) }
        attr_protected :created_at, :updated_at
        
        include MuckActivities::Models::MuckActivityItem
        include MuckComments::Models::MuckCommentable
      end
      
      # Adds activities for the share.
      def add_share_activity(share_to = nil, attach_to = nil)
        share_to ||= self.shared_by.feed_to
        share_to = [share_to] unless share_to.is_a?(Array)
        share_to << self.shared_by unless share_to.include?(self.shared_by) # make sure the person doing the sharing is included
        add_activity(share_to, self.shared_by, self, 'share', '', '', nil, attach_to)
      end
      
      # override this method to change the way permissions are handled on shares
      def can_edit?(user)
        return true if check_sharer(user)
        false
      end

    end
  end
end
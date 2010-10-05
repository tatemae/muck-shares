module MuckShares
  module Models
    module Share
      
      included do

        belongs_to :shared_by, :class_name => "User" , :foreign_key => :shared_by_id
        validates_presence_of :uri
        validates_presence_of :title
          
          MuckActivities::Models::ActivityItem
          include MuckComments::Models::Commentable
          
        named_scope :by_newest, :order => "created_at DESC"
        named_scope :by_oldest, :order => "created_at ASC"
        named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
                            
        attr_protected :created_at, :updated_at
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
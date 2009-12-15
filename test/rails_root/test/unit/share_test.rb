require File.dirname(__FILE__) + '/../test_helper'

class ShareTest < ActiveSupport::TestCase
  
  context "Share" do
    setup do
      @user = Factory(:user)
      @friend = Factory(:user)
      @share = @user.shares.build(Factory.attributes_for(:share))
      @share.save!
    end
    
    subject { @share }
    
    should_validate_presence_of :uri
    
    should_belong_to :shared_by
    should_have_many :comments
    
    should_scope_by_newest
    should_scope_by_oldest
    should_scope_recent
    
    should "require uri" do
      assert_no_difference 'Share.count' do
        u = Factory.build(:share, :uri => nil)
        assert !u.valid?
        assert u.errors.on(:uri)
      end
    end
    
    should "Add an activity" do
      assert_difference "Activity.count", 1 do
        @share.add_share_activity(@user)
      end
    end
    
    should "Add an activity without specifying share_to" do
      assert_difference "Activity.count", 1 do
        @share.add_share_activity
      end
    end
    
    should "Add an activity for self and friend" do
      activity = @share.add_share_activity([@user, @friend])
      @user.reload
      @friend.reload      
      assert @user.activities.include?(activity)
      assert @friend.activities.include?(activity)
    end
    
    context "user that created share" do
      should "be able to edit the share" do
        assert @share.can_edit?(@user)
      end
    end
  end

end
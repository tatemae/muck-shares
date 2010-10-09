require File.dirname(__FILE__) + '/../spec_helper'

describe Share do

  before do
    @user = Factory(:user)
    @other_user = Factory(:user)
    @friend = Factory(:user)
    @share = @user.shares.build(Factory.attributes_for(:share, :shared_by => @other_user))
    @share.save!
  end
  
  it { should validate_presence_of :uri }
  
  it { should belong_to :shared_by }
  it { should have_many :comments }
  
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  
  it "should require uri" do
    lambda{
      u = Factory.build(:share, :uri => nil)
      u.should_not be_valid
      u.errors[:uri].should_not be_empty
    }.should_not change(Share, :count)
  end
  
  it "should add an activity" do
    lambda{
      @share.add_share_activity(@user)
    }.should change(Activity, :count).by(1)
  end
  
  it "should add an activity without specifying share_to" do
    lambda{
      @share.add_share_activity
    }.should change(Activity, :count).by(1)
  end
  
  it "should add an activity for self and friend" do
    activity = @share.add_share_activity([@user, @friend])
    @user.reload
    @friend.reload      
    @user.activities.should include(activity)
    @friend.activities.should include(activity)
  end
  
  describe "user that created share" do
    it "should be able to edit the share" do
      @share.can_edit?(@other_user).should be_true
    end
  end
  
end
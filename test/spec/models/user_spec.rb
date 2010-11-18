require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  describe "A user that can share" do
    
    before do
      @user = Factory(:user)
      @other_user = Factory(:user)
      @share = @user.shares.build(Factory.attributes_for(:share, :shared_by => @other_user))
      @share.save!
    end
    
    it { should have_many :shares }
      
    it "should add shares to the user" do
      @user.shares.length.should == 1
    end
    # TODO can add the count cache later on if we need it
    # it "should have share cache" do
    #   @user.reload
    #   @user.share_count.should == 1
    # end
  end

end
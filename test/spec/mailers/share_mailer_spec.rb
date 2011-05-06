require File.dirname(__FILE__) + '/../spec_helper'

describe ShareMailer do

  describe "deliver emails" do

    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end
    
    it "should send ishare email" do
      contact_email = Factory.next(:email)
      user = Factory(:user)
      subject = 'test subject'
      email = ShareMailer.share_email(user, contact_email, subject, 'test message').deliver
      ActionMailer::Base.deliveries.should_not be_empty
      email.subject.should == subject
      email.to.should == [contact_email]
      email.from.should == [user.email]
    end

  end  
end

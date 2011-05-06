require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::EmailSharesController do

  render_views
  
  it { should require_login :new, :get }
  it { should require_login :create, :post }
  
  describe "logged in" do
    before do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
    end

    describe "GET new" do
      before do
        @message = 'test'
        get :new, :message => @message
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :new }
      it "should set message" do
        assigns(:message).should == @message
      end
    end
  
    describe "POST create" do
      describe "empty emails" do
        describe "html" do
          before do
            post :create,  :emails => ""
          end
          it "should set message" do
            assigns(:result).should == I18n.translate('muck.shares.emails_empty')
          end
        end
        describe "js" do
          before do
            post :create,  :emails => "", :format => 'js'
          end
          it { should respond_with :success }
          it "should set message" do
            assigns(:result).should == I18n.translate('muck.shares.emails_empty')
          end
        end
        describe "pjs" do
          before do
            post :create,  :emails => "", :format => 'pjs'
          end
          it { should respond_with :success }
          it "should set message" do
            assigns(:result).should == I18n.translate('muck.shares.emails_empty')
          end
        end
      end
      describe "valid emails and message" do
        before do
          @message = 'Share this!'
        end
        describe "string of emails" do
          before do
            @emails = "#{Factory.next(:email)},#{Factory.next(:email)}"
          end
          it "should send a share email to each email specified by string" do
            ShareMailer.should_receive(:share_email).exactly(2).times.and_return(mock(:deliver => nil))
            post :create, :emails => @emails, :message => @message
          end
          it "should set result to a success message" do
            post :create, :emails => @emails, :message => @message
            assigns(:result).should == I18n.translate('muck.shares.share_email_success', :emails => @emails)
          end
        end
        describe "array of emails" do
          before do
            @emails = [[Factory.next(:email),Factory.next(:email)]]
          end
          it "should send a share email to each email specified by array" do
            ShareMailer.should_receive(:share_email).exactly(2).times.and_return(mock(:deliver => nil))
            post :create, :emails => @emails, :message => @message
          end
          it "should set result to a success message" do
            post :create, :emails => @emails, :message => @message
            assigns(:result).should == I18n.translate('muck.shares.share_email_success', :emails => @emails.join(','))
          end
        end
      end
      
    end
    
  end
      
end
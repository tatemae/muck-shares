require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::SharesController do

  render_views
  
  before do
    @other_user = Factory(:user)
  end
  
  describe "not logged in" do
    before do
      @user = Factory(:user)
    end
    describe "GET index user specified" do
      before do
        @user.shares.build(Factory.attributes_for(:share, :shared_by => @other_user))
        @user.shares.build(Factory.attributes_for(:share, :shared_by => @other_user))
        get :index, :user_id => @user.to_param, :format => 'html'
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end
  end
  
  describe "logged in" do
    before do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
    end

    describe "GET new" do
      before do
        get :new
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :new }
    end

    describe "GET new with" do
      before do
        @title = 'Example'
        @uri = 'http://www.example.com'
        @message = 'a message'
      end
      describe "full params" do
        before do
          get :new, :uri => @uri, :title => @title, :message => @message
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :new }
        it "should setup the share" do
          @uri.should == assigns(:share).uri
          @title.should == assigns(:share).title
          @message.should == assigns(:share).message
        end
      end
      describe "min params" do
        before do
          get :new, :u => @uri, :t => @title, :m => @message
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :new }
        it "should setup the share" do
          @uri.should == assigns(:share).uri
          @title.should == assigns(:share).title
          @message.should == assigns(:share).message
        end
      end
    end

    describe "GET index no user specified" do
      before do
        @user.shares.create(Factory.attributes_for(:share, :shared_by => @other_user))
        @user.shares.create(Factory.attributes_for(:share, :shared_by => @other_user))
        get :index, :format => 'html'
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end
  
    describe "GET index user specified" do
      before do
        @user.shares.create(Factory.attributes_for(:share, :shared_by => @other_user))
        @user.shares.create(Factory.attributes_for(:share, :shared_by => @other_user))
        get :index, :user_id => @user.to_param, :format => 'html'
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end
    
    describe "DELETE to destroy" do
      before do
        @share = @other_user.shares.create(Factory.attributes_for(:share, :shared_by => @user))
        @no_delete_share = Factory(:share)
      end
      describe 'html' do
        it "should delete share" do
          lambda{
            delete :destroy, :id => @share.to_param
            should set_the_flash.to(I18n.t('muck.shares.share_removed'))
            should redirect_to @user
          }.should change(Share, :count).by(-1)
        end
        it "should not delete share" do
          lambda{
            delete :destroy, :id => @no_delete_share.to_param
          }.should_not change(Share, :count)
        end
        
      end
      describe 'js' do
        it "should delete share" do
          lambda{
            delete :destroy, :id => @share.to_param, :format => 'js'
            response.body.should include('jQuery')          
          }.should change(Share, :count).by(-1)
        end
        it "should not delete share" do
          lambda{
            delete :destroy, :id => @no_delete_share.to_param, :format => 'js'
          }.should_not change(Share, :count)
        end

      end
      describe 'json' do
        it "should delete share" do
          lambda{
            delete :destroy, :id => @share.to_param, :format => 'json'
            response.body.should include(I18n.t('muck.shares.share_removed'))          
          }.should change(Share, :count).by(-1)
        end
        it "should not delete share" do
          lambda{
            delete :destroy, :id => @no_delete_share.to_param, :format => 'json'
          }.should_not change(Share, :count)
        end
      end
    end

  end

end
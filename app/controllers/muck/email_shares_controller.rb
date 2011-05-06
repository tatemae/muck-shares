class Muck::EmailSharesController < ApplicationController
  
  before_filter :login_required
  
  def new
    flash.discard
    @emails = params[:emails]
    @message = CGI.unescape(params[:message] || '')
    @subject = CGI.unescape(params[:subject] || '')
    respond_to do |format|
      format.html { render :template => 'email_shares/new', :layout => 'popup' }
      format.pjs { render :template => 'email_shares/new', :layout => false }
      format.js { render :template => 'email_shares/new', :layout => false }
    end
  end
  
  def create
    if params[:emails].blank?
      @result = t('muck.shares.emails_empty')
    elsif params[:message].blank?
      @result = t('muck.shares.message_empty')
    else
      @emails = params[:emails]
      @emails = @emails.join(', ') if @emails.is_a?(Array)
      @emails = @emails.split(/[, ]/) if !@emails.is_a?(Array)
      @emails = @emails.find_all { |email| !email.blank? }
      @emails = @emails.flatten.collect { |email| email.strip }
      check_emails = []
      subject = params[:subject]
      message = params[:message]
      @emails.each do |email|
        if !check_emails.include?(email)
          check_emails << email
          response = ShareMailer.share_email(current_user, email, subject, message).deliver
        end
      end
      @emails = @emails.join(',')
      @result = t('muck.shares.share_email_success', :emails => @emails)
      @success = true
    end
    respond_to do |format|
      format.html do
        flash[:notice] = @result
        render :template => 'email_shares/new', :layout => 'popup'
      end
      format.pjs { render :template => 'email_shares/create', :layout => false  }
      format.js { render :template => 'email_shares/create', :layout => false }
    end 
  end
  
end
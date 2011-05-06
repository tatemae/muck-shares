class ShareMailer < ActionMailer::Base

  def share_email(user, email, subject, message)
    @message = message
    @user = user
    mail(:to => email, :from => user.email, :subject => subject) do |format|
      format.html
      format.text
    end
  end
  
end
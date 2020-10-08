class AuthorizeMailer < ApplicationMailer
  def admin_email user
    @user = user
    mail to: @user.email, subject: t("authorize_mailer.authorize.admin")
  end

  def member_email user
    @user = user
    mail to: @user.email, subject: t("authorize_mailer.authorize.member")
  end
end

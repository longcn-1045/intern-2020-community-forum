class BlockMailer < ApplicationMailer
  def block_email user
    @user = user
    mail to: @user.email, subject: t("block_mailer.blocked_email.block")
  end

  def unblock_email user
    @user = user
    mail to: @user.email, subject: t("block_mailer.blocked_email.unblock")
  end
end

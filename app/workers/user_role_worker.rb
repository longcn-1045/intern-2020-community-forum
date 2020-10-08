class UserRoleWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform profile
    @user = User.find profile["user_id"]
    AuthorizeMailer.send("#{@user.role}_email", @user).deliver
  end
end

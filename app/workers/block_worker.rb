class BlockWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform profile
    @user = User.find profile["user_id"]
    BlockMailer.send("#{@user.status}_email", @user).deliver
  end
end

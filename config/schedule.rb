set :environment, :development
set :output, "log/cron_log.log"

every 1.day do
  runner "Post.check_post"
end

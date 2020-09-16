class StaticPagesController < ApplicationController
  before_action :logged_in_user

  def home
    user_ids = current_user.following_ids << current_user.id
    topic_ids = current_user.topic_ids

    @posts = Post.includes(:topic, :tags, :user, :post_likes, :post_marks)
                 .by_topics(topic_ids)
                 .or Post.includes(:topic, :tags, :user,
                                   :post_likes, :post_marks)
                         .by_users(user_ids)
    @posts = @posts.sort_by(&:post_score).reverse!
  end

  def help; end

  def about; end

  def contact; end
end

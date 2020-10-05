class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def home
    user_ids = current_user.following_ids << current_user.id
    topic_ids = current_user.topic_ids
    if topic_ids.present? || current_user.following_ids.present?
      @posts = Post.includes(:topic, :tags, :user, :post_likes, :post_marks)
                   .in_homepage topic_ids, user_ids
      @posts = @posts.sort_by(&:post_score).reverse!
    else
      @posts = current_user.posts.on
    end
  end

  def help; end

  def about; end

  def contact; end
end

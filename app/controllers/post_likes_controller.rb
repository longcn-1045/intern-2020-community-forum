class PostLikesController < ApplicationController
  authorize_resource

  before_action :authenticate_user!
  before_action :find_post, only: %i(create destroy)

  def create
    current_user.like_post @post
    check_liked_post

    respond_to :js
  end

  def destroy
    current_user.unlike_post @post
    check_unliked_post

    respond_to :js
  end

  private

  def find_post
    @post = Post.find_by id: params[:post_id]
    return if @post

    @error = t ".not_found"
  end

  def check_liked_post
    @error = t ".unliked_post" unless current_user.like_post? @post
  end

  def check_unliked_post
    @error = t ".liked_post" if current_user.like_post? @post
  end
end

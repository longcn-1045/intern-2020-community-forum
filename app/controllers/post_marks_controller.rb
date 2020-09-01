class PostMarksController < ApplicationController
  before_action :logged_in_user
  before_action :find_post, only: %i(create destroy)

  def create
    if @post.present?
      current_user.save_post @post
    end

    respond_to :js
  end

  def destroy
    if @post.present?
      current_user.unsave_post @post
    end

    respond_to :js
  end

  private

  def find_post
    @post = Post.find_by id: params[:post_id]
    return if @post

    @error = t ".not_found"
  end
end

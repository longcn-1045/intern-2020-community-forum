class PostMarksController < ApplicationController
  before_action :logged_in_user
  before_action :find_post, only: %i(create destroy)

  def create
    if @post.present?
      if current_user.save_post? @post
        @error = t ".saved_post"
      else
        current_user.save_post @post
        record_activity "You have marked post #{@post.title}"
      end
    end

    respond_to :js
  end

  def destroy
    if @post.present?
      if current_user.save_post? @post
        current_user.unsave_post @post
        record_activity "You have unmarked post #{@post.title}"
      else
        @error = t ".unsaved_post"
      end
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

class PostMarksController < ApplicationController
  before_action :logged_in_user
  before_action :find_post, only: %i(create destroy)

  def create
    if @post.present?
      if current_user.save_post? @post
        @error = t ".saved_post"
      else
        current_user.save_post @post
        @error = t ".unsaved_post" unless current_user.save_post? @post
      end
    end

    respond_to :js
  end

  def destroy
    if @post.present?
      if current_user.save_post? @post
        current_user.unsave_post @post
        @error = t ".saved_post" if current_user.save_post? @post
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

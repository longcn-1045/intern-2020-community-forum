class PostMarksController < ApplicationController
  before_action :logged_in_user
  before_action :find_post, only: %i(create destroy)

  def create
    current_user.save_post @post
    check_saved_post

    respond_to :js
  end

  def destroy
    current_user.unsave_post @post
    check_unsaved_post

    respond_to :js
  end

  private

  def find_post
    @post = Post.find_by id: params[:post_id]
    return if @post

    @error = t ".not_found"
  end

  def check_saved_post
    @error = t ".unsaved_post" unless current_user.save_post? @post
  end

  def check_unsaved_post
    @error = t ".saved_post" if current_user.save_post? @post
  end
end

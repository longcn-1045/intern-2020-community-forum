class PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    if @error.blank?
      @post_comment = @commentable
                      .post_comments
                      .new post_comment_params.merge user_id: current_user.id
      @error = t(".comment_failed") unless @post_comment.save
    end

    respond_to :js
  end

  private

  def load_commentable
    resource, id = request.path.split("/")[Settings.load_commentable,
                                           Settings.load_commentable]
    @commentable = resource.singularize.classify.constantize.find_by id: id
    return if @commentable

    @error = t(".not_found")
  end

  def post_comment_params
    params.require(:post_comment).permit PostComment::PERMIT_ATTRIBUTES
  end
end

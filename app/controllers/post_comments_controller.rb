class PostCommentsController < ApplicationController
  before_action :logged_in_user
  before_action :load_commentable, only: :create

  def create
    @post_comments = @commentable.post_comments.new post_comment_params
    @post_comments.user_id = current_user.id
    if @post_comments.save
      redirect_to @commentable
    else
      redirect_to @commentable
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[2,2]
    @commentable = resource.singularize.classify.constantize.find id
  end

  def post_comment_params
    params.require(:post_comment).permit!
  end
end

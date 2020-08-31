class PostsController < ApplicationController
  before_action :find_post, only: %i(edit update destroy show)

  def index; end

  def show; end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:success] = t ".post_created"
    else
      flash[:danger] = t ".post_create_failed"
    end
    redirect_to root_url
  end

  def edit; end

  def update
    if @post.update post_params
      flash[:success] = t ".post_updated"
    else
      flash[:danger] = t ".post_update_failed"
    end
    redirect_to root_url
  end

  def destroy; end

  private

  def post_params
    params.require(:post).permit :content, :title, :topic_id
  end

  def find_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end

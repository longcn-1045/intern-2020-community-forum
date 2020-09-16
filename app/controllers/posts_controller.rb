class PostsController < ApplicationController
  before_action :logged_in_user, except: %i(index show)
  before_action :find_post, except: %i(new create index)

  def index; end

  def show; end

  def new
    @post = Post.new
    @post.tags.build
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:success] = t ".post_created"
      redirect_to root_url
    else
      flash[:danger] = t ".post_create_failed"
      render :new
    end
  end

  def edit
    @post.tags.build
  end

  def update
    if @post.update post_params
      flash[:success] = t ".post_updated"
      redirect_to root_url
    else
      flash[:danger] = t ".post_update_failed"
      render :edit
    end
  end

  def destroy; end

  private

  def post_params
    params.require(:post).permit Post::POST_PARAMS
  end

  def find_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end

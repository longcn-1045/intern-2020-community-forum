class Admin::PostsController < AdminController
  before_action :authenticate_user!
  before_action :load_post, except: %i(index new create)
  before_action :load_element, :post_include, only: :index

  before_action :check_user, only: %i(update post_process)

  include PostsHelper

  add_breadcrumb I18n.t("posts.breadcrumbs.post"), :admin_posts_path

  def index
    search_element "Post"
    @posts = @posts.page(params[:page]).per params[:per_page]
  end

  def new
    add_breadcrumb I18n.t("posts.breadcrumbs.new")
    @post = current_user.posts.build
  end

  def show
    load_notification if params[:notification_id].present?
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:notice] = t "post.controller.create_success"
      redirect_to admin_posts_path
    else
      flash.now[:alert] = t "post.controller.create_failed"
      render :new
    end
  end

  def edit
    add_breadcrumb I18n.t("posts.breadcrumbs.edit")
  end

  def update
    if @post.update post_params
      flash[:notice] = t "users.update.success"
      redirect_to admin_posts_path
    else
      flash[:alert] = t "users.update.fail"
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = t "post.controller.deleted_success"
    else
      flash.now[:alert] = t "post.controller.deleted_error"
    end
    redirect_to admin_posts_path
  end

  def post_process
    @post.status = params[:option]
    @post.save
    flash[:notice] = t "users.update.success"
    redirect_to admin_posts_path
  end

  private

  def check_user
    return unless current_user.admin?

    @post.editor_id = current_user.id
  end

  def post_params
    params.require(:post).permit Post::POST_PARAMS
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:alert] = t "post.controller.not_found"
    redirect_to admin_posts_path
  end

  def load_element
    @users = User.all
    @topics = Topic.all
  end

  def post_include
    @q = Post.ransack params[:q].try(:merge, m: "or")
    @posts = @q.result.includes :user, :topic
  end

  def load_notification
    @notify = Notification.find_by id: params[:notification_id]
    if @notify.present?
      @notify.checked!
    else
      flash[:alert] = t "users.controller.not_found"
      redirect_to admin_posts_path
    end
  end
end

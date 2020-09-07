class Admin::TopicsController < AdminController
  before_action :load_topic, except: %i(index new create)

  add_breadcrumb I18n.t("topic.breadcrumbs.list"), :admin_topics_path

  def index
    @topics = Topic.order_created_at.page(params[:page]).per Settings.post.page
  end

  def new
    add_breadcrumb I18n.t("topic.breadcrumbs.new")
    @topic = Topic.new
  end

  def show; end

  def create
    @topic = Topic.new topic_params
    if @topic.save
      flash[:info] = t "topic.controller.create_success"
      redirect_to admin_topics_path
    else
      flash.now[:danger] = t "topic.controller.create_failed"
      render :new
    end
  end

  def edit
    add_breadcrumb I18n.t("topic.breadcrumbs.edit")
  end

  def update
    if @topic.update topic_params
      flash[:success] = t "users.update.success"
      redirect_to admin_topics_path
    else
      flash[:danger] = t "users.update.fail"
      render :edit
    end
  end

  def destroy
    if @topic.destroy
      flash[:success] = t "topic.controller.deleted_success"
    else
      flash.now[:danger] = t "topic.controller.deleted_error"
    end
    redirect_to admin_topics_path
  end

  def activate
    if @topic.on?
      flash[:success] = t "topic.controller.activate_success"
      @topic.off!
    else
      flash.now[:danger] = t "topic.controller.activate_error"
      @topic.on!
    end
    redirect_to admin_topics_path
  end

  private

  def topic_params
    params.require(:topic).permit Topic::TOPIC_PARAMS
  end

  def load_topic
    @topic = Topic.find_by id: params[:id]
    return if @topic

    flash[:danger] = t "topic.controller.not_found"
    redirect_to admin_topics_path
  end
end

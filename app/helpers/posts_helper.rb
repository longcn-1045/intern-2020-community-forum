module PostsHelper
  def list_topics
    Topic.pluck :name, :id
  end
end

module PostsHelper
  def load_dropdown model
    model.pluck :name, :id
  end

  def list_tags
    Tag.all.select(:id, :name).map{|tag| [tag.name, tag.id]}
  end

  def list_topics
    Topic.all.select(:id, :name).map{|topic| [topic.name, topic.id]}
  end
end

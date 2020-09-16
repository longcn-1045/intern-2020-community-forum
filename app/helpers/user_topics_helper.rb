module UserTopicsHelper
  def build_user_topic
    current_user.user_topics.build
  end

  def find_user_topic topic
    current_user.user_topics.find_by topic_id: topic.id
  end
end

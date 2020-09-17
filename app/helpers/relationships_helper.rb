module RelationshipsHelper
  def follow
    current_user.active_relationships.build
  end

  def unfollow user
    current_user.active_relationships.find_by followed_id: user.id
  end
end

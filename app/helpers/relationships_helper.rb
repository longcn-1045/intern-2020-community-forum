module RelationshipsHelper
  def build_relationships
    current_user.active_relationships.build
  end

  def find_relationships user
    current_user.active_relationships.find_by followed_id: user.id
  end
end

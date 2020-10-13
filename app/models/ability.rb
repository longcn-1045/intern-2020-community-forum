class Ability
  include CanCan::Ability

  def initialize user
    can :manage, User, role: "member"

    return if user.blank?

    cannot :create, User
    can :manage, Post
    can :read, Topic
    can %i(create destroy), PostLike, user_id: user.id
    can :create, PostReport, user_id: user.id
    can %i(create destroy), PostMark, user_id: user.id
    can %i(create destroy), UserTopic, user_id: user.id
    can %i(read create destroy), Relationship, user_id: user.id
    can %i(read create), Activity, user_id: user.id
    can %i(read create), PostComment, user_id: user.id
  end
end

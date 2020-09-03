module UsersHelper
  def user_status status
    if status
      {
        css: Settings.status.active,
        status: t("users.index.active")
      }
    else
      {
        css: Settings.status.block,
        status: t("users.index.block")
      }
    end
  end

  def user_role role
    if role
      {
        css: Settings.status.member,
        status: t("users.index.member")
      }
    else
      {
        css: Settings.status.admin,
        status: t("users.index.admin")
      }
    end
  end
end

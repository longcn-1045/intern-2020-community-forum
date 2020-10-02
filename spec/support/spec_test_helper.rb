module SpecTestHelper
  def login user
    request.session[:user_id] = user.id
  end

  def nil_session
    request.session[:user_id] = nil
  end

  def current_user
    User.find_by id: request.session[:user_id]
  end

  def admin?
    current_user.admin?
  end
end

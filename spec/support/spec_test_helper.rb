module SpecTestHelper
  def login user
    request.session[:user_id] = user.id
  end

  def nil_session
    request.session[:user_id] = nil
  end
end

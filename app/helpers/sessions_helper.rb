module SessionsHelper

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sing_out
    session.delete(:user_id)
  end

  def current_use
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_sign_in?
    !current_use().nil?
  end
end

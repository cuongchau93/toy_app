module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    # temporary cookies created using the session method are automatically encrypted
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged-in user (if any).
  def current_user
    # using session
    # method 1
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end
    # method 2
    ## @current_user = @current_user || User.find_by(id: session[:user_id])
    # method 3
    # @current_user ||= User.find_by(id: session[:user_id])

    # using cookies instead
    # if session[:user_id]
    #   @current_user ||= User.find_by(id: session[:user_id])
    # elsif cookies.signed[:user_id]
    #   user = User.find_by(id: cookies.signed[:user_id])
    #   if user && user.authenticated?(cookies[:remember_token])
    #     log_in user
    #     @current_user = user
    #   end
    # end

    # using cookies instead but making the use of sessions and cookies more similar
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end

  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
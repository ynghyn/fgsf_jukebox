class ApplicationController < ActionController::Base
  before_action :get_or_create_user

  protect_from_forgery with: :exception

  def current_user
    @current_user
  end

  protected

  def get_or_create_user
    if cookies[:user_id] && user = User.find_by_id(cookies[:user_id])
      user.update_attribute(:last_visited, Time.zone.now) if 1.hour.ago > user.last_visited
      @current_user = user
    else
      @current_user = User.create(last_visited: Time.zone.now)
      cookies[:user_id] = { value: @current_user.id, expires: 3.years.from_now }
    end
  end
end

class ApplicationController < ActionController::Base
  helper :all
  ensure_application_is_installed_by_facebook_user

  layout false

  def find_or_create_user
    @user = User.find_or_create_by_id(facebook_session.user.to_i)
  end

  before_filter :find_or_create_user
end

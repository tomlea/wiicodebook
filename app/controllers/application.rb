class ApplicationController < ActionController::Base
  helper :all

  class << self
    def is_live?
      RAILS_ENV === "production"
    end
    
    def is_development?
      !is_live?
    end
  end

  

  layout false

  ensure_application_is_installed_by_facebook_user

  if is_live?
    def find_or_create_user
      if params[:format] == :fbml
        @user = User.find_or_create_by_id(facebook_session.user.to_i)
      else
        session[:user_id] = params.delete(:user_id){session[:user_id]}
        session[:friends] = params.delete(:friends){session[:friends]}
        @user = User.find_or_create_by_id(session[:user_id])
      end
    end
  else
    def find_or_create_user
      @user = User.find_or_create_by_id(facebook_session.user.to_i)
    end
  end
  before_filter :find_or_create_user
end


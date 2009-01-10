class HomeController < ApplicationController
  def index
    @current_facebook_user = facebook_session.user
  end
end

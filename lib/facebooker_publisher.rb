class FacebookerPublisher < Facebooker::Rails::Publisher
  def profile_for_user(user_to_update)
      send_as :profile
      from user_to_update
      recipients user_to_update
      @user = User.find_or_create_by_id(user_to_update.uid)
      @game_codes = @user.friend_codes(:include => :games)
      fbml = render(:partial =>"/friend_codes/profile.fbml.erb", :locals => {:user => @user, :game_codes => @game_codes})
      profile(fbml)
  end

  def mini_feed_game_codes_updated(user)
    send_as :templatized_action
    self.from( user)
    title_template "{actor} <fb:if-multiple-actors>have<fb:else>has</fb:else></fb:if-multiple-actors> <a href=\"#{root_url}\">updated Wii friend codes</a>."
    RAILS_DEFAULT_LOGGER.debug("Sending mini feed story for user #{user.id}")
  end

end


class FriendCodesController < ApplicationController
  layout "dashboard"

  protected
  def game_codes_by_game_id(games, friend_codes)
    friend_codes.inject({}){|acc, fc| acc.merge(fc.game_id => fc)}
  end

  def my_facebook_friends
    if self.class.is_development?
      session[:friends] || []
    else
      facebook_session.user.friends.map{|u| u.to_i}
    end
  end

  public
  def edit
    @games = Game.find(:all)
    @game_codes_by_game_id = game_codes_by_game_id(@games, @user.friend_codes)
  end

  def index
    @friends = User.find(:all, :include => {:friend_codes => :game}, :conditions => {:id => my_facebook_friends})
    @friends.reject! do |friend|
      friend.friend_code.nil? and friend.friend_codes.empty?
    end
  end

  def list_not_added
    @friend_codes = FriendCode.find(:all, :include => :game, :conditions => {:user_id => my_facebook_friends}).flatten
    @friend_codes_added, @friend_codes_not_added = @friend_codes.partition{|fc| @user.has_added_friend_code?(fc)}
  end

  def mark_as_entered
    friend_code = FriendCode.find(params[:friend_code_id])
    @user.friend_code_addeds.find_or_create_by_friend_code_id(friend_code.id)
    flash[:notice] = "Friend code marked as added"
    redirect_to :action => :list_not_added
  end

  #TODO: Finnish moving over to WiiConole type object
  def update
    @games = Game.find(:all)
    @game_codes_by_game_id = game_codes_by_game_id(@games, @user.friend_codes)
    @friend_codes_to_be_deleted = []

    params[:game_code].each do |id, code|
      if code.nil? or code == ""
        if @game_codes_by_game_id.has_key? id.to_i
          @friend_codes_to_be_deleted << @game_codes_by_game_id[id.to_i]
          @game_codes_by_game_id.delete id.to_i
        end
      elsif @game_codes_by_game_id[id.to_i].nil?
        @game_codes_by_game_id[id.to_i] = @user.friend_codes.build(:game_id => id.to_i, :friend_code => code)
      else
        @game_codes_by_game_id[id.to_i].friend_code = code
      end
    end if params[:game_code]

    User.transaction do
      @friend_codes_to_be_deleted.compact.each{|fc| fc.destroy }

      if @game_codes_by_game_id.values.compact.map{|gc| gc.save }.all?
        unless self.class.is_development?
          FacebookerPublisher.deliver_profile_for_user(facebook_session.user)
          FacebookerPublisher.deliver_mini_feed_game_codes_updated(facebook_session.user)
        end
        flash[:notice] = "Friend codes updated"
        redirect_to :action => :edit
      else
        render :action => :edit
        raise ActiveRecord::Rollback
      end
    end
  end
end


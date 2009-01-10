class FriendCodesController < ApplicationController
  layout "dashboard"

  protected
  def game_codes_by_game_id(games, friend_codes)
    empty = games.inject({}){|acc, g| acc.merge(g.id => nil)}
    friend_codes.inject(empty){|acc, fc| acc.merge(fc.game_id => fc)}
  end

  def validate_game_code(code)
    code.nil? or code =~ /^[0-9]{4}-[0-9]{4}-[0-9]{4}$/
  end

  def validate_wii_code(code)
    code.nil? or code =~ /^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$/
  end

  def clean_game_code(code)
    return nil if code.nil? or code == ""
    slices = []
    code.gsub(/[ \-]*/, '').split('').each_slice(4){|slice| slices << slice.join("") }
    slices.join("-")
  end

  def my_facebook_friends
    facebook_session.user.friends.inject([]){|c, u| c << u.to_i}
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
    @game_codes = @user.friend_codes(:include => :games )
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

  def update
    @user.friend_code = clean_game_code(params[:friend_code])
    @games = Game.find(:all)
    @game_codes_by_game_id = game_codes_by_game_id(@games, @user.friend_codes)
    @friend_codes_to_be_deleted = []
    params[:game_code].each do |id, code|
      if clean_game_code(code).nil?
        @friend_codes_to_be_deleted << @game_codes_by_game_id[id.to_i]
        @game_codes_by_game_id[id.to_i] = nil
      elsif @game_codes_by_game_id[id.to_i].nil?
        @game_codes_by_game_id[id.to_i] = @user.friend_codes.build(:game_id => id.to_i, :friend_code => clean_game_code(code))
      else
        @game_codes_by_game_id[id.to_i].friend_code = clean_game_code(code)
      end
    end if params[:game_code]

    unless validate_wii_code(clean_game_code(params[:friend_code]))
      @user.friend_code = params[:friend_code]
      flash[:error] = "Invalid Wii friend code."
      render :action => :edit
      return
    end

    params[:game_code].each do |id, code|
      unless validate_game_code(clean_game_code(code))
        @game_codes_by_game_id[id.to_i].friend_code = code
        flash[:error] = "Invalid friend code for #{@game_codes_by_game_id[id.to_i].game.name}."
        render :action => :edit
        return
      end
    end if params[:game_code]
    
    begin
      User.transaction do
        @friend_codes_to_be_deleted.compact.each{|fc| fc.destroy }
        
        if @user.save! && @game_codes_by_game_id.values.compact.each{|gc| gc.save! }.all?
          FacebookerPublisher.deliver_profile_for_user(facebook_session.user)
          FacebookerPublisher.deliver_mini_feed_game_codes_updated(facebook_session.user)
          flash[:notice] = "Friend codes updated"
          redirect_to :action => :edit        
        end
      end 
    rescue Exception => e
      logger.warn e.to_s
      flash[:error] = "Error saving friend codes."
      render :action => :edit        
    end
  end
end

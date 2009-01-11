require File.dirname(__FILE__) + '/../test_helper'

class FriendCodesControllerTest < ActionController::TestCase
  def test_should_mark_friend_codes_as_entered
    user = Factory(:user)
    friend_code = Factory(:friend_code)
    
    post :mark_as_entered, :friend_code_id => friend_code.id, :user_id => user.id
    
    assert user.has_added_friend_code?(friend_code)
  end
end

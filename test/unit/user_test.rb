require File.dirname(__FILE__) + '/../test_helper'

class UserHasAddedFriendCodeAddedTest < Test::Unit::TestCase
  def test_user_should_know_no_friend_code_has_been_added
    user = Factory(:user)
    friend_code = Factory(:friend_code)
    
    assert !user.has_added_friend_code?(friend_code)
  end
  
  def test_user_should_know_friend_code_has_been_added
    user = Factory(:user)
    friend_code = Factory(:friend_code)
    user.add_friend_code(friend_code)
    
    assert user.has_added_friend_code?(friend_code)
  end

  def test_user_should_not_know_about_other_unrelated_friend_codes
    Factory(:user).add_friend_code(Factory(:friend_code))
    
    user = Factory(:user)
    friend_code = Factory(:friend_code)
    friend_code2 = Factory(:friend_code)
    
    user.add_friend_code(friend_code2)
    
    assert !user.has_added_friend_code?(friend_code)
  end
end

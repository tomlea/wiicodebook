require File.dirname(__FILE__) + '/../test_helper'

class FriendCodeValidationTest < Test::Unit::TestCase
  def test_should_validate_based_on_the_related_game
    friend_code = FriendCode.new
    friend_code.user = Factory(:user)
    friend_code.game = game = Factory(:wii_game)
    friend_code.friend_code = "NOTAVALIDCODE"

    assert !friend_code.save, "FriendCode should not save with a bad game code."
    assert_equal [["friend_code", "is not a valid #{game.name} friend code."]], friend_code.errors.to_a
  end

  def test_should_accept_a_valid_and_formatted_code
    friend_code = FriendCode.new
    friend_code.user = Factory(:user)
    friend_code.game = game = Factory(:wii_game)
    friend_code.friend_code = "0000-0000-0000"

    assert friend_code.save!
  end

  def test_should_accept_a_valid_but_poorly_formatted_code
    friend_code = FriendCode.new
    friend_code.user = Factory(:user)
    friend_code.game = game = Factory(:wii_game)
    friend_code.friend_code = "000000000000"

    assert friend_code.save!
  end

  def test_valid_code_should_be_reformatted_to_look_nice_when_saving
    friend_code = FriendCode.new
    friend_code.user = Factory(:user)
    friend_code.game = game = Factory(:wii_game)
    friend_code.friend_code = "000000000000"

    friend_code.save!
    
    assert_equal "0000-0000-0000", friend_code.friend_code
  end

  def test_should_require_a_game
    friend_code = FriendCode.new
    friend_code.user = Factory(:user)

    assert !friend_code.save, "FriendCode should not save without an associated game."
    assert_equal [["game", "is not set."]], friend_code.errors.to_a
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class TestController < ApplicationController
end

class TestControllerTest < ActionController::TestCase
  def test_controller_should_have_access_to_the_facebook_session
    assert_respond_to @controller, :facebook_session
  end
end

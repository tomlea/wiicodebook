class FriendCodeAdded < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend_code
end

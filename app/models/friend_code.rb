class FriendCode < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :friend_code_addeds
end

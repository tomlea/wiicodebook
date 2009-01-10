class User < ActiveRecord::Base
  has_many :friend_codes
  has_many :friend_code_addeds

  def has_added_friend_code?(friend_code)
    friend_code.user_id == self.id or
      friend_code_addeds.find(:all, :include => :friend_code).any? do |fca|
        fca.friend_code == friend_code
      end
  end
end


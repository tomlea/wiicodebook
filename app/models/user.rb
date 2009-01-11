class User < ActiveRecord::Base
  has_many :friend_codes
  has_many :friend_code_addeds

  def has_added_friend_code?(friend_code)
    return true if friend_code.user_id == self.id    
    friend_code_addeds.count(:conditions => {:friend_code_id => friend_code.id}) > 0
  end
  
  def add_friend_code(friend_code)
    friend_code_addeds.create!(:friend_code => friend_code)
  end
end


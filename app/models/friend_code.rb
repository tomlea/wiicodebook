class FriendCode < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :friend_code_addeds
  
  validate :validate_game_is_defined
  def validate_game_is_defined
    errors.add(:game, "is not set.") if game.nil?
  end
  
  validate :ensure_correct_format
  def ensure_correct_format
    if game and not game.code_is_valid_when_clean?(friend_code)
      errors.add(:friend_code, "is not a valid #{game.name} friend code.")
    end
  end

  before_save :fix_friend_code_format
  def fix_friend_code_format
    self.friend_code = game.clean_code(friend_code)
  end
end


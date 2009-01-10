class CreateFriendCodes < ActiveRecord::Migration
  def self.up
    create_table :friend_codes do |t|
      t.references :user
      t.references :game
      t.string :friend_code
    end
    
    add_index :friend_codes, :user_id
    add_index :friend_codes, :game_id    
  end

  def self.down
    drop_table :friend_codes
  end
end

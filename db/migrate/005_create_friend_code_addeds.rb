class CreateFriendCodeAddeds < ActiveRecord::Migration
  def self.up
    create_table :friend_code_addeds do |t|
      t.references :user
      t.references :friend_code
    end
    
    add_index :friend_code_addeds, :friend_code_id
    add_index :friend_code_addeds, :user_id
  end

  def self.down
    drop_table :friend_code_addeds
  end
end

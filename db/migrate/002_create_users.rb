class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :friend_code
    end
  end

  def self.down
    drop_table :users
  end
end

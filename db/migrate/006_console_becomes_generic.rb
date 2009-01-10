class ConsoleBecomesGeneric < ActiveRecord::Migration
  def self.up
    add_column :games, :type, :string
    User.transaction do
      Game.find(:all) do |game|
        game.type = "WiiGame"
        game.save!
      end
      
      console = WiiConsole.create(:name => "Wii Console")
      
      User.find(:all).each do |user|
        unless user.friend_code.nil?
          console.friend_codes.create(:user => user, :friend_code => user.friend_code)
        end
      end
    end
    
  end

  def self.down    
    remove_column :games, :type
    
    WiiConsole.find(:all).each do |wc|
      wc.destroy
    end
  end
end

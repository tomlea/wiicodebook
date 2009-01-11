Factory.define :user do |u|
end

Factory.define :wii_game do |g|
  g.name "Game With a Name"
end

Factory.sequence :wii_game_code do |i|
  "%012i" % i
end

Factory.define :friend_code do |fc|
  fc.game {|a| a.association(:wii_game) }
  fc.friend_code { Factory.next :wii_game_code }
end

ActionController::Routing::Routes.draw do |map|
  map.root :controller => "friend_codes"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

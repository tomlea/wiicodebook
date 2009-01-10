RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "cwninja-facebooker", :lib => "facebooker", :source => "http://gems.github.com"
  config.action_controller.session_store = :active_record_store
end

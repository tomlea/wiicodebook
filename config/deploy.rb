default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :repository,  "git@github.com:cwninja/wiicodebook.git"
set :scm, "git"
set :branch, "master"

set :application, "wiicodebook"

set :deploy_to, "/apps/#{application}"

role :app, "jack.clockworkninjas.co.uk"
role :web, "jack.clockworkninjas.co.uk"
role :db,  "jack.clockworkninjas.co.uk", :primary => true


task :import_private_files do     
  run "cp #{shared_path}/config/* #{release_path}/config/"
end    

after "deploy:update_code", :import_private_files

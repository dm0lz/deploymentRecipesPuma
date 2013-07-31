set :rvm_type, :system
set :rvm_ruby_string, "2.0.0"              # use the same ruby as used locally for deployment
#set :rvm_ruby_string, 'release_path'	  # will load ruby from the deployed code using .rvmrc or other file like .ruby-version
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs
#set :rvm_ruby_string, "1.9.3-p392"              # use the same ruby as used locally for deployment
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_install_with_sudo, true
before 'deploy:setup', 'rvm:install_rvm'  # install RVM
before 'deploy:setup', 'rvm:install_ruby' # install Ruby and create gemset, OR:
#before 'deploy:setup', 'rvm:create_gemset' # only create gemset

#Disabling bundle --deployment when using gemsets
#Using gemsets is safer from bundle --deployment which is default, to disable it use:
#set :bundle_dir, ''
#set :bundle_flags, '--system --quiet'

#require "rvm/capistrano/alias_and_wrapp"
#before 'deploy:setup', 'rvm:create_alias'
#before 'deploy:setup', 'rvm:create_wrappers'




#The problem may be that you need to create the bundler wrapper. You can do that this way(in your deploy.rb, for example)

#require "rvm/capistrano" # http://beginrescueend.com/integration/capistrano/

# rvm-capistrano settings
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")

#namespace :rvm do
#  task :create_bundle_wrapper, roles: :app do
#    run "rvm wrapper #{rvm_ruby_string} bundle bundle"
#  end  
#end
#
#after "deploy:create_symlink", "rvm:create_bundle_wrapper"
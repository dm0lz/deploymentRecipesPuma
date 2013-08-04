set_default(:mysql_host, "localhost")
set_default(:mysql_user, "rails" )
set_default(:mysql_password) { Capistrano::CLI.password_prompt "Mysql Password: " }
set_default(:mysql_database) { "#{application}_production" }

namespace :mysql do
  desc "Install the latest stable release of Mysql."
  task :install, :roles => :db, :only => {:primary => true} do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install mysql-server mysql-client libmysqlclient-dev"
  end
  after "deploy:install", "mysql:install"

  desc "Create a database for this application."
  task :create_database do
    #set :root_password, Capistrano::CLI.password_prompt("MySQL root password: ")
    #set :db_user, Capistrano::CLI.ui.ask("Application database user: ")
    #set :db_pass, Capistrano::CLI.password_prompt("Password: ")
    #set :db_name, Capistrano::CLI.ui.ask("Database name: ")
      
    run "mysql --user=#{mysql_user} --password=#{mysql_password} -e \"CREATE DATABASE IF NOT EXISTS #{mysql_database}\""
    #run "mysql --user=root --password=#{root_password} -e \"GRANT ALL PRIVILEGES ON #{db_name}.* TO '#{db_user}'@'localhost' IDENTIFIED BY '#{db_pass}' WITH GRANT OPTION\""
  end
  after "deploy:setup", "mysql:create_database"

  desc "Generate the database.yml configuration file."
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template "mysql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "mysql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "mysql:symlink"
end

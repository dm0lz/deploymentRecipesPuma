

namespace :smtp_config do

  desc "Get Credentials"
  task :get_credentials, :roles => :app do
    set :gmail_username, Capistrano::CLI.ui.ask("gmail_username : ")
    set :gmail_password, Capistrano::CLI.ui.ask("gmail_password : ")
  end
  after "deploy:setup", "smtp_config:get_credentials"
  
  desc "Generate the smtp.yml configuration file."
  task :setup_file, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template "smtp.yml.erb", "#{shared_path}/config/smtp.yml"
  end
  after "deploy:setup", "smtp_config:setup_file"

  desc "Symlink the smtp.yml file into latest release"
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/smtp.yml #{release_path}/config/smtp.yml"
  end
  after "deploy:finalize_update", "smtp_config:symlink"

end
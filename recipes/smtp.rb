
  # Add to config/environments/production.rb

  #config.before_configuration do
  #  env_file = File.join(Rails.root, 'config', 'smtp.yml')
  #  YAML.load(File.open(env_file)).each do |key, value|
  #    ENV[key.to_s] = value
  #  end if File.exists?(env_file)
  #end
  #config.action_mailer.smtp_settings = {
  #  :address              => "smtp.gmail.com",
  #  :port                 => 587,
  #  :domain               => "yogic-sadhana.com",
  #  :user_name            => ENV["GMAIL_USERNAME"],
  #  :password             => ENV["GMAIL_PASSWORD"],
  #  :authentication       => :plain,
  #  :enable_starttls_auto => true
  #}

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
#!/bin/bash

apt-get -y update && apt-get -y upgrade && apt-get -y install curl && apt-get -y install git-core && apt-get -y install python-software-properties && apt-get -y install locate
#apt-get -y update && apt-get -y upgrade 
#apt-get -y install curl 
#apt-get -y install git-core  
#apt-get -y install python-software-properties
#apt-get -y install locate

# rvm & ruby
\curl -L https://get.rvm.io | bash
source /etc/profile.d/rvm.sh
rvm requirements
rvm install 1.9.3

# nginx
add-apt-repository ppa:nginx/stable && apt-get -y update && apt-get -y install nginx && service nginx start
#add-apt-repository ppa:nginx/stable
#apt-get -y update
#apt-get -y install nginx
#service nginx start

# add user
adduser olivierdo
/usr/sbin/visudo
#=> add olivierdo to sudoers => olivierdo       ALL=(ALL:ALL) ALL
#=> olivierdo ALL= NOPASSWD: /etc/init.d/unicorn_deployTest
su olivierdo
sudo usermod -a -G rvm olivierdo if install rvm :system
cat ~/.ssh/id_rsa.pub | ssh olivierdo@185.14.184.133 'cat >> ~/.ssh/authorized_keys'

# mysql
apt-get install -y mysql-server && apt-get install -y libmysqlclient-dev && apt-get install -y mysql-client
#apt-get install -y mysql-server
#apt-get install -y libmysqlclient-dev
#apt-get install -y mysql-client
sudo mysql_install_db
sudo /usr/bin/mysql_secure_installation
mysql -u root -p PASSWORD
# CREATE USER 'rails'@'localhost' IDENTIFIED BY 'PASSWORD';
# GRANT ALL PRIVILEGES ON * . * TO 'rails'@'localhost';
# FLUSH PRIVILEGES;

# PostgreSQL
add-apt-repository ppa:pitti/postgresql
apt-get -y update
apt-get -y install postgresql libpq-dev
sudo -u postgres psql
# \password
# create user blog with password 'secret';
# create database blog_production owner blog;
# \q

# Postfix
apt-get -y install telnet postfix

# Node.js
add-apt-repository ppa:chris-lea/node.js && apt-get -y update && apt-get -y install nodejs
#add-apt-repository ppa:chris-lea/node.js
#apt-get -y update
#apt-get -y install nodejs




# rbenv
curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
vim ~/.bashrc # add rbenv to the top
. ~/.bashrc
rbenv bootstrap-ubuntu-10-04
rbenv install 1.9.3-p125
rbenv global 1.9.3-p125
gem install bundler --no-ri --no-rdoc
rbenv rehash

# get to know github.com
ssh git@github.com




# Apache (instead of nginx)
apt-get -y install apache2
a2enmod rewrite
# after deploy:
sudo a2dissite default
sudo a2ensite blog
sudo /etc/init.d/apache2 reload

# MySQL (instead of PostgreSQL)
apt-get -y install mysql-server mysql-client libmysqlclient-dev
mysql -u root -p
# create database blog_production;
# grant all on blog_production.* to blog@localhost identified by 'secret';
# exit

# Compile Ruby (instead of rbenv)
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline5-dev libyaml-dev
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p125.tar.gz
tar -xvzf ruby-1.9.3-p125.tar.gz
cd ruby-1.9.3-p125/
./configure --prefix=/usr/local
make
sudo make install
sudo gem install bundler --no-ri --no-rdoc

# Phusion Passenger (instead of Unicorn)
sudo apt-get -y install libcurl4-openssl-dev apache2-prefork-dev libapr1-dev libaprutil1-dev
sudo gem install passenger --no-ri --no-rdoc
sudo passenger-install-apache2-module
sudo vim /etc/apache2/apache2.conf # modify as instructed by installer


###### Alternative Deploy #####################

config/deploy.rb
# ...
namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, roles: :app, except: {no_release: true} do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/apache.conf /etc/apache2/sites-available/#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"
  # ...
end


config/apache.conf
<VirtualHost *:80>
  # ServerName example.com
  # ServerAlias *.example.com
  DocumentRoot /home/deployer/apps/blog/current/public
  <Directory "/home/deployer/apps/blog/current/public">
    Options FollowSymLinks
    AllowOverride None
    Order allow,deny
    Allow from all
  </Directory>
</VirtualHost>
namespace :node do
	desc "install node"
	task :install, role: :web do
		run "#{sudo} add-apt-repository ppa:chris-lea/node.js"
		run "#{sudo} apt-get -y update"
		run "#{sudo} apt-get -y install nodejs"
	end
	after "deploy:install", "node:install"
end
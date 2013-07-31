set_default(:puma_pid) { "#{current_path}/tmp/pids/puma.pid" }
set_default(:puma_state) { "#{shared_path}/tmp/pids/puma.state" }
set_default(:puma_sock) { "#{shared_path}/tmp/sockets/puma.sock" }
set_default(:puma_sock_ctl) { "#{shared_path}/tmp/sockets/pumactl.sock" }
set_default(:puma_config) { "#{shared_path}/config/puma.rb" }
set_default(:puma_user) { user }

namespace :puma do

	desc "Setup puma config"	
	task :setup, roles: :app do
		run "mkdir -p #{shared_path}/config"
		template "puma.rb.erb", puma_config
		template "puma_init.erb", "/tmp/puma_init"
	    run "chmod +x /tmp/puma_init"
	    run "#{sudo} mv /tmp/puma_init /etc/init.d/puma_#{application}"
	    run "#{sudo} update-rc.d -f puma_#{application} defaults"
	end
	after "deploy:setup", "puma:setup"

	%w[start stop restart].each do |command|
	    desc "#{command} Puma"
	    task command, roles: :app do
	      	run "service puma_#{application} #{command}"
	    end
	    after "deploy:#{command}", "puma:#{command}"
  end
  
end

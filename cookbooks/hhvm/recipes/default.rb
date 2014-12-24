#
# Cookbook Name:: hhvm
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Add repo settings
bash "Add repo settings" do
	cwd "/etc/yum.repos.d"
	code <<-EOC
		rm hop5.repo
		wget http://www.hop5.in/yum/el6/hop5.repo
		echo 'priority=9' >> hop5.repo
		echo 'includepkgs=glog,tbb' >> hop5.repo
		rm sexydev-amazon.repo
		wget http://yum.sexydev.com/sexydev-amazon.repo
	EOC
end
bash "clean yum" do
	code "yum clean all"
end	

# Install packages
%w(boost-system boost-thread boost-chrono libicu mpfr libmpc boost-regex boost-filesystem boost-program-options boost-date-time boost-wave boost-graph cpp48 boost-locale boost-timer boost-iostreams boost-python libc-client boost-signals jemalloc gd libunwind glog boost-serialization boost-context boost-random oniguruma boost-test libevent libstdc++48-devel unixODBC boost-atomic libdwarf boost-math boost tbb kernel-headers glibc-headers glibc-devel gcc48 gcc48-c++ hhvm hiphop-php).each do |pkg|
	package pkg do
		action :install
	end
end 

# Log directory for hhvm
directory "/var/log/hhvm" do
	owner "root"
	group "root"
	mode 0755
	action :create
end	

# pid directory for hhvm
directory "/var/run/hhvm" do
	owner "apache"
	group "root"
	mode "0755"
	action :create
end

# hhvm conf file
template "/etc/hhvm/server.ini" do
	owner "root"
	group "root"
	mode 0644
end

# Enable & Start hhvm service
service "hhvm" do
	action [:enable, :start]
	supports :status => true, :restart => true, :reload => true
end

bash "Restart hhvm" do
	code <<-EOC
		/etc/init.d/hhvm restart
	EOC
end

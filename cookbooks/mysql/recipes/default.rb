#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Packages to install
packages = %w{mysql-server mysql}

case node[ :platform ]
	when 'redhat', 'centos', 'amazon'
	packages.each do |pkg|
		package pkg do
			action :install
			#options "--enablerepo=remi"
		end
	end

	when 'debian', 'ubuntu'
	packages.each do |pkg|
		package pkg do
			action :install
		end
	end
end

service "mysqld" do
    supports :restart => true
    action [:start, :enable]
end

# Create dba user
mysql_create_user(node[:mysql][:dba][:user], node[:mysql][:dba][:password])


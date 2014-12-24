#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install package
package "nginx" do
	action :install
end

# Make config files
template "/etc/nginx/nginx.conf" do
	owner "root"
	group "root"
	mode 0644
end

template "/etc/nginx/conf.d/drupal.conf" do
	owner "root"
	group "root"
	mode 0644
end

template "/etc/nginx/hhvm.conf" do
	owner "root"
	group "root"
	mode 0644
end

# Enable & Start nginx  service
service "nginx" do
	action [:enable, :start]
	supports :status => true, :restart => true, :reload => true
end


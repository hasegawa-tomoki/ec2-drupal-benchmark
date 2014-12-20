#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
conf_file = "/etc/httpd/conf/httpd.conf"

# Install package
package "httpd24" do
	action :install
end

# Create DocumentRoot
directory "/var/www/#{node[:project][:code_name]}" do
	owner "root"
	group "root"
	mode 0755
end

# Make httpd.conf
template "/etc/httpd/conf/httpd.conf" do
	owner "root"
	group "root"
	mode 0644
end

# Set ServerName
append2file(conf_file, "ServerName", "ServerName #{node[:project][:code_name]}")

# Enable & Start Apache service
service "httpd" do
    action [:enable, :start]
    supports :status => true, :restart => true, :reload => true
end


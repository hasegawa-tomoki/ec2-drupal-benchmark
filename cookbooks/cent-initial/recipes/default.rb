#
# Cookbook Name:: cent-initial
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Add epel, remi repository
bash 'add_epel' do
  user 'root'
  code <<-EOC
    rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo
  EOC
  creates "/etc/yum.repos.d/epel.repo"
end

bash 'add_remi' do
  user 'root'
  code <<-EOC
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi.repo
  EOC
  creates "/etc/yum.repos.d/remi.repo"
end

# Install basic packages.
%w{mlocate bind-utils}.each do |pkg|
	package pkg do
		action :install
	end
end

# Disable iptables
service "iptables" do
    action [:disable, :stop]
end

# Change root user's prompt
_prompt = 'PS1="\[\033[0;36m\][\u@\h \w]$\[\033[0m\] "'
%w{root}.each do |user|
	append2file("~#{user}/.bashrc", "prompt", _prompt)
end


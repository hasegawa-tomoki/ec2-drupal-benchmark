#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w(php55 php55-cli php55-common php55-gd php55-mbstring php55-mcrypt php55-mysqlnd php55-opcache php55-pdo php55-pecl-imagick php55-pecl-memcache php55-pecl-memcached php55-tidy php55-xml).each do |pkg|
	package pkg do
		action :install
		notifies :restart, "service[httpd]"
	end
end

# Install composer
composer_bin = "/usr/local/bin/composer"
bash "Install composer" do
	cwd "/tmp"
	code <<-EOC
		curl -sS https://getcomposer.org/installer | php
		mv composer.phar #{composer_bin}
		chown root.root #{composer_bin}
	EOC
	not_if { ::File.exists? composer_bin }    
end
# Add path to composer
append2file("/root/.bashrc", "Path to composer", 'export PATH="$HOME/.composer/vendor/bin:$PATH"')


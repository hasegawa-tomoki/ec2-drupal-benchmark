#
# Cookbook Name:: restore-drupal
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/tmp/drupal.sql"

bash "Install Drupal" do
	code <<-EOC
		mysql -uroot drupal < /tmp/drupal.sql
	EOC
end

cookbook_file "/var/www/drupal/sites/default/settings.php" do
	owner "apache"
	group "apache"
	mode 0644
end


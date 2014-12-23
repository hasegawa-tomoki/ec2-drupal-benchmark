# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install Drush using composer
bash "Composer configure" do
	code <<-EOC
		composer global require drush/drush:6.*
		composer global install
	EOC
	not_if { File.exist?("/root/.composer/vendor/bin/drush") }
end

# Install Drupal using Drush
project_dir = "/var/www/#{node[:project][:code_name]}"
bash "Install Drupal to #{project_dir}" do
	code <<-EOC
		cd /var/www
		/root/.composer/vendor/bin/drush dl drupal-#{node[:drupal][:version]}
		rmdir #{node[:project][:code_name]}
		mv drupal-#{node[:drupal][:version]} #{node[:project][:code_name]}
	EOC
	not_if { File.exist?(project_dir + "/README.txt") }
end

# Install Drupal modules using Drush
module_dir = "#{project_dir}/sites/all/modules/"
node[:drupal][:modules].each do |mod_with_version|
	components = mod_with_version.split("-")
	mod_name = components[0]

	if ! ::Dir.exists?("#{module_dir}#{mod_name}") then
		bash "Install Drupal module #{mod_with_version}" do
			cwd project_dir
			code <<-EOC
				/root/.composer/vendor/bin/drush dl #{mod_with_version}
			EOC
		end
	end
end

# Make all files owner to apache
bash "Change Drupal files owner to apache" do
	cwd "/var/www/"
	code <<-EOC
		chown -R apache.apache #{project_dir}
	EOC
end
# Create settings.php
settings_file = "#{project_dir}/sites/default/settings.php"
bash "Create initial settings.php" do
	code <<-EOC
		cp #{project_dir}/sites/default/default.settings.php #{settings_file}
		chown apache.apache #{settings_file}
	EOC
	not_if { File.exists?(settings_file) }
end
# Create sites/default/files directory
directory "#{project_dir}/sites/default/files" do
	owner "apache"
	group "apache"
	mode 0755
	action :create
end
# Set parmissions 
bash "Change file/directory permissions for Drupal" do
	code <<-EOC
		chmod 644 #{settings_file}	
	EOC
end

# Create database user
mysql_create_user(node[:project][:mysql][:user], node[:project][:mysql][:password])
# Create database
mysql_create_database(node[:project][:mysql][:database], node[:project][:mysql][:user])

# Put Japanese translations file
cookbook_file "#{project_dir}/profiles/standard/translations/drupal-7.34.ja.po" do
	owner "apache"
	group "apache"
	mode 0644
end



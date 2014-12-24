# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile for Amazon EC2 Benchmark.
# requires Vagrant plugin: unf vagrant-aws vagrant-omnibus

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# Box setting
	config.vm.box = "dummy"
	config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
	# Install Chef Client / Chef Solo using vagrant-omnibus plugin.
	config.omnibus.chef_version = :latest

	["t2.micro", "t2.small", "t2.medium", "m3.medium", "m3.large", "m3.xlarge", "m3.2xlarge", "c3.large", "c3.xlarge", "c3.2xlarge", "c3.4xlarge", "c3.8xlarge"].each do |instance_type|
		config.vm.define "#{instance_type}" do |node|
			node.vm.hostname = "#{instance_type}"

			node.vm.provider :aws do |aws, override|
				# Set Access Key ID and Secret Access Key from shell environment.
				aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
				aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
	
				# EC2 Instance setting
				aws.region = "ap-northeast-1"
				aws.availability_zone = "ap-northeast-1a"
				aws.instance_type = instance_type
				aws.elastic_ip = true
				# Amazon Linux AMI 2014.09.1 (HVM)
				aws.ami = "ami-4985b048"
				aws.subnet_id = ENV['AWS_SUBNET_ID']
				
				aws.keypair_name = ENV['AWS_KEYPAIR_NAME']

				# SSH setting
				override.ssh.username = "ec2-user"
				override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']
				
				# Edit /etc/sudoers for sudo without tty
				aws.user_data = "#!/bin/sh\nsed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers\n"
			end
			# Make benchmark
			node.vm.provision :chef_solo do |chef|
				chef.add_recipe "libraries"
				chef.add_recipe "cent-initial"
				chef.add_recipe "apache2"
				chef.add_recipe "mysql"
				chef.add_recipe "php"
				chef.add_recipe "git"
				chef.add_recipe "drupal"
				chef.add_recipe "nginx"
				chef.add_recipe "hhvm"

				# Uncomment if you want to restore Drupal using drupal.sql and settings.php
				# drupal.sql: mysqldump -uroot drupal > drupal.sql
				# settings.php: /var/www/drupal/sites/default/settings.php
				# chef.add_recipe "restore-drupal"

				chef.json = {
					"project" => {
						"code_name" => "drupal",
						"mysql" => {
							"database" => "drupal",
							"user" => "drupal", 
							"password" => "3bjrg8sz"
						}
					},
					"mysql" => {
						"dba" => {
							"user" => "dba", 
							"password" => "z6x7bur2"
						}
					},
					"drupal" => {
						"version" => "7.34",
						"modules" => [
						]
					}
				}
			end
		end
	end
end


def mysql_create_user(user, password)
	bash "create mysql user #{user}" do
		code <<-EOC
			echo "GRANT ALL ON *.* TO '#{user}'@'localhost' IDENTIFIED BY '#{password}'; FLUSH PRIVILEGES;" | mysql -uroot
		EOC
	end
end

def mysql_create_database(database, user)
	bash "create mysql database #{database}" do
		code <<-EOC
			echo "create database if not exists #{database} character set utf8;grant all on #{database}.* to '#{user}'@'localhost'; flush privileges;" | mysql -uroot
		EOC
	end
end






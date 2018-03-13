#!/usr/bin/env bash

# install
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
apt-get install -y mysql-server

# user && privileges
mysql -u root -proot -e "CREATE USER IF NOT EXISTS 'vagrant'@'%' IDENTIFIED BY 'vagrant'"
mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS vagrant";
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION; FLUSH PRIVILEGES; SET GLOBAL max_connect_errors=10000;"

# allow remote connection
sed -i "s/^bind-address/#bind-address/" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s/^skip-external-locking/#skip-external-locking/" /etc/mysql/mariadb.conf.d/50-server.cnf

# end
systemctl restart mysql

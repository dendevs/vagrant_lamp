#!/usr/bin/env bash

apt-get update

# Apache
apt-get install -y apache2
systemctl stop apache2
if ! [ -L /var/www ]; then
    rm -rf /var/www
    ln -fs /vagrant_src /var/www
fi
if ! [ -e /etc/apache2/sites-available/000-default.conf ]; then
    rm -f /etc/apache2/sites-available/000-default.conf
    ln -fs /vagrant_config/apache/000-default.conf /etc/apache2/sites-enabled/000-default.conf
fi
systemctl start apache2

# Php ( php7.0-dev pour phpsize utile à pecl )
apt-get install -y php php-pear php7.0-dev composer
pecl install xdebug
if ! [ -L /etc/php/7.0/apache2/php.ini ]; then
    rm -f /etc/php/7.0/apache2/php.ini
    ln -fs /vagrant_config/php/apache/php.ini /etc/php/7.0/apache2/php.ini
    systemctl reload apache2
fi
if ! [ -L /etc/php/7.0/cli/php.ini ]; then
    rm -f /etc/php/7.0/cli/php.ini
    ln -fs /vagrant_config/php/cli/php.ini /etc/php/7.0/cli/php.ini
fi

# Mysql
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
apt-get install mysql-server
# user mysql
mysql -u root -proot -e "CREATE USER 'vagrant'@'%' IDENTIFIED BY 'vagrant'"
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION; FLUSH PRIVILEGES; SET GLOBAL max_connect_errors=10000;"
# allow remote connection
sed -i "s/^bind-address/#bind-address/" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s/^skip-external-locking/#skip-external-locking/" /etc/mysql/mariadb.conf.d/50-server.cnf
# end
systemctl restart mysql

# Utils
apt-get install -y net-tools lynx vim aptitude git git-flow htop


# Docs
# mysql
# https://github.com/AlexDisler/mysql-vagrant/blob/master/install.sh
# https://serversforhackers.com/c/installing-mysql-with-debconf



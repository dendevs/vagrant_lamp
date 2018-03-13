#!/usr/bin/env bash

# install
apt-get install -y apache2

# mods
a2enmod rewrite

# vhosts
sed -i "/^\s*DocumentRoot \/var\/www\/html/c\    DocumentRoot \/var\/www/" /etc/apache2/sites-enabled/000-default.conf
if ! [ -L /var/www ]; then
    rm -rf /var/www
    ln -fs /vagrant_src /var/www
fi
cp -f /vagrant_config/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# end
systemctl restart apache2
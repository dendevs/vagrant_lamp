#!/usr/bin/env bash

# install
apt-get install -y apache2

# mods
a2enmod rewrite

# apache on shared directory
#if ! [ -L /var/www ]; then
#    rm -rf /var/www
#    ln -fs /vagrant_src /var/www
#fi

# vhosts
sed -i "s/^DocumentRoot \/var\/www\/html/#DocumentRoot \/var\/www\//" /etc/apache2/sites-enabled/000-default.conf
if ! [ -L /var/www/vagrant ]; then
    rm -rf /var/www/vagrant
    ln -fs /vagrant_src /var/www/vagrant
fi
if ! [ -e /etc/apache2/sites/available/001-vagrant.conf ]; then
    ln -fs /vagrant_config/apache/001-vagrant.conf /etc/apache2/sites-available/001-vagrant.conf
    a2ensite 001-vagrant.conf
fi

# end
systemctl restart apache2
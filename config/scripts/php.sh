#!/usr/bin/env bash

# install ( php7.0-dev pour phpsize utile à pecl )
apt-get install -y php php-pear php7.0-dev composer

export DEBIAN_FRONTEND="noninteractive"
apt-get install -y php-mysql

# config
if ! [ -L /etc/php/7.0/apache2/php.ini ]; then
    rm -f /etc/php/7.0/apache2/php.ini
    ln -fs /vagrant_config/php/apache/php.ini /etc/php/7.0/apache2/php.ini
fi
if ! [ -L /etc/php/7.0/cli/php.ini ]; then
    rm -f /etc/php/7.0/cli/php.ini
    ln -fs /vagrant_config/php/cli/php.ini /etc/php/7.0/cli/php.ini
fi

# phpinfo
echo "<?php phpinfo(); ?>" > /var/www/info.php

# debug
pecl install xdebug

# end
systemctl restart apache2

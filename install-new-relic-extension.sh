#!/bin/bash

for VERSION in "7.4" "8.0" "8.1"  "8.2"
do
    mkdir /output/extension/$VERSION
    apt-get -qy install php$VERSION-dev
    make clean && 
    update-alternatives --set php /usr/bin/php$VERSION && 
    update-alternatives --set phpize /usr/bin/phpize$VERSION && 
    update-alternatives --set php-config /usr/bin/php-config$VERSION && 
    make all && cp agent/modules/newrelic.so /output/extension/$VERSION/.
    apt-get -qy remove php$VERSION-dev
done
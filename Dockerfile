FROM php:7.1-apache

ENV apt_install="apt install -y --no-install-recommends"

ENV COMPOSER_VERSION master
ENV DEBIAN_FRONTEND noninteractive

RUN apt update 

RUN $apt_install apt-utils

# package git is needed for composer install command
RUN $apt_install git 

# php gd support
RUN $apt_install libjpeg62-turbo-dev libpng-dev libfreetype6-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 
RUN docker-php-ext-install -j$(nproc) gd

#mycrypt
#RUN apt-get install -y  --no-install-recommends libmcrypt
#RUN docker-php-ext-install -j$(nproc) mcrypt

RUN docker-php-ext-install -j$(nproc) mbstring iconv  bcmath

#PHP soap support: 
RUN DEBIAN_FRONTEND=noninteractive \
 $apt_install libxml2-dev && docker-php-ext-install -j$(nproc) soap

#PHP database extensions database (mysql)
RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql

#xdebug
RUN $apt_install autoconf $PHPIZE_DEPS && pecl install xdebug-2.6.0 && docker-php-ext-enable xdebug

ENV COMPOSER_VERSION master
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN $apt_install unzip
RUN docker-php-ext-install -j$(nproc) zip

#APACHE_RUN_USER
RUN cd .. && rm -r html && composer create-project oxid-esales/oxideshop-project . dev-b-6.1-ce && mv source html

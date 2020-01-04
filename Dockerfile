FROM php:7.3.6-fpm

RUN apt-get update
RUN apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libgd-dev libjpeg-dev libpng-dev libwebp-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-webp-dir=/usr/include/  --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN apt-get install -y --no-install-recommends libgmp-dev
RUN docker-php-ext-install gmp
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-enable opcache
RUN apt-get autoclean -y
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/pear/
RUN pecl install -o -f redis
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install sockets
RUN docker-php-ext-install sysvmsg exif
RUN apt-get update && apt-get install -y zlib1g-dev libzip-dev
RUN apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN pecl install imagick
RUN docker-php-ext-enable imagick
RUN docker-php-ext-install zip
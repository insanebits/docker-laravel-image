FROM php:7.3.6-fpm

# Install dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    libgmp-dev \
    libz-dev \
    libmemcached-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    libicu-dev

# Cleanup
RUN apt-get autoclean -y

# Install PECL and PEAR extensions
RUN pecl install \
    memcached \
    redis \
    xdebug

# Configure php extensions
RUN docker-php-ext-configure \
    intl

# Install php extensions
RUN docker-php-ext-install \
    gmp \
    pdo_mysql \
    opcache \
    bcmath \
    pcntl \
    sysvmsg \
    intl

# Enable php extensions
RUN docker-php-ext-enable \
    opcache \
    memcached \
    xdebug
# Add php extensions configuration
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

COPY opencensus-ext/* /tmp/opencensus/

RUN cd /tmp/opencensus \
    && phpize \
    && ./configure --enable-opencensus \
    && make -j "$(nproc)" \
    && make install \
    && cd ~ \
    && rm -r /tmp/opencensus \
    && docker-php-ext-enable opencensus

# Cleanup
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/pear/

# Setup working directory
WORKDIR /var/www

# Set maintainer label
LABEL maintainer="rdereskevicius@gmail.com"

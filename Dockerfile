FROM php:7.3-apache-stretch

RUN apt-get update && apt-get install -y \
      cron \
      libjpeg-dev \
      libfreetype6-dev \
      libpng-dev \
      libssl-dev \
      zip \
      libzip-dev \
      ssmtp \
 && rm -rf /var/lib/apt/lists/*

#RUN docker-php-ext-install mbstring

RUN docker-php-ext-configure gd \
 && docker-php-ext-install gd mysqli pdo_mysql zip ftp

RUN a2enmod rewrite
COPY apache2.conf /etc/apache2/apache2.conf

ENV OXWALL_VERSION 1.8.0

RUN curl -fsSL -o oxwall.zip \
      "http://www.oxwall.org/dl/oxwall-$OXWALL_VERSION.zip" \
 && mkdir -p /usr/src/oxwall \
 && mv oxwall.zip /usr/src/oxwall/ \
 && cd /usr/src/oxwall \
 && unzip oxwall.zip \
 && rm oxwall.zip

COPY php.ini /usr/local/etc/php/php.ini
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]

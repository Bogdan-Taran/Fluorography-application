FROM php:8.3-fpm-alpine

RUN apk add --no-cache \
    postgresql-dev \
    curl \
    unzip \
    git \
    bash \
    icu-dev \
    zlib-dev \
    libpng-dev \
    libxml2-dev \
    oniguruma-dev


RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    mbstring \
    bcmath \
    intl \
    opcache \
    xml


RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

COPY ./backend /var/www

RUN composer install --prefer-dist --optimize-autoloader --no-interaction

RUN chown -R www-data:www-data .

EXPOSE 9000

CMD ["php-fpm"]
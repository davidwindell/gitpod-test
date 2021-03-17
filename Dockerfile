FROM outeredge/edge-docker-magento:2.2.10 AS magento
FROM outeredge/edge-docker-magento:1.9.4.4-php7 AS magento1
FROM outeredge/edge-docker-php:7.2

ENV APPLICATION_ENV=dev \
    MAGE_IS_DEVELOPER_MODE=true

CMD ["/dev.sh"]

ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_DISPLAY_ERRORS=On \
    ENABLE_DEV=On \
    ENABLE_REDIS=On \
    XDEBUG_ENABLE=On

COPY --chown=edge . /

RUN sudo apt-get update \
    && sudo apt-get install --no-install-recommends --yes \
        imagemagick \
        jq \
        sassc \
        mysql-client \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-imagick \
        vim \
    # Install Magerun
    && sudo wget https://files.magerun.net/n98-magerun2.phar -O /usr/local/bin/magerun2 \
    && sudo chmod +x /usr/local/bin/magerun2 \
    && sudo wget https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash -P /etc/profile.d \
    # Preserve prestissimo for composer 1
    && if [ "$COMPOSER_VERSION" = "1" ]; then mv /home/edge/.composer /home/edge/.composer.orig; fi \
    # Create gitpod user and group
    && sudo addgroup --gid 33333 --system gitpod \
    && sudo adduser --uid 33333 --system --shell /bin/bash --ingroup gitpod gitpod \
    && sudo addgroup gitpod edge \
    && sudo addgroup gitpod sudo \
    && sudo addgroup nginx gitpod \
    && sudo addgroup www-data gitpod \
    && sudo cp -rf /home/edge/. /home/gitpod/ \
    && sudo chown -R gitpod:gitpod /home/gitpod/ \
    # Cleanup
    && sudo rm -rf /var/lib/apt/lists/*

COPY --from=magento /etc/nginx/magento_default.conf /etc/nginx/
COPY --from=magento /templates/nginx-magento.conf.j2 /templates/
COPY --from=magento1 /etc/nginx/magento_security.conf /etc/nginx/
COPY --from=magento1 /templates/nginx-magento.conf.j2 /templates/nginx-magento1.conf.j2

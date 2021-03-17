FROM outeredge/edge-docker-php:7.1

CMD ["/dev.sh"]

ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_DISPLAY_ERRORS=On \
    ENABLE_DEV=On \
    ENABLE_REDIS=On \
    XDEBUG_ENABLE=On

COPY --chown=edge . /

RUN sudo addgroup --gid 33333 --system gitpod \
    && sudo adduser --uid 33333 --system --shell /bin/bash --ingroup gitpod gitpod \
    && sudo addgroup gitpod edge \
    && sudo addgroup gitpod sudo \
    && sudo addgroup nginx gitpod \
    && sudo addgroup www-data gitpod \
    && sudo cp -rf /home/edge/. /home/gitpod/ \
    && sudo chown -R gitpod:gitpod /home/gitpod/ \
    # Cleanup
    && sudo rm -rf /var/lib/apt/lists/*

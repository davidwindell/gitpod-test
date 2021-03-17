FROM outeredge/edge-docker-php:7.1

ENV ENABLE_DEV=On

COPY --chown=edge . /

RUN sudo addgroup --gid 33333 --system gitpod \
    && sudo adduser --uid 33333 --system --shell /bin/bash --ingroup gitpod gitpod \
    && sudo addgroup gitpod edge \
    && sudo addgroup gitpod sudo \
    && sudo addgroup nginx gitpod \
    && sudo addgroup www-data gitpod \
    && sudo chown -R gitpod:gitpod /home/gitpod/

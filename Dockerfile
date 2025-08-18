FROM python:3.13.7-alpine

MAINTAINER Shane Mc Cormack <dataforce@dataforce.org.uk>
LABEL org.opencontainers.image.authors "Shane Mc Cormack <dataforce@dataforce.org.uk>"
LABEL org.opencontainers.image.description "exabgp in Docker."
LABEL org.opencontainers.image.url "https://github.com/ShaneMcC/docker-exabgp"

ARG EXABGP_VERSION=4.2.25

RUN apk add wget dumb-init git bash curl

WORKDIR /opt/exabgp

RUN wget https://github.com/Exa-Networks/exabgp/archive/refs/tags/${EXABGP_VERSION}.tar.gz -O exabgp.tgz \
    && tar --strip-components=1 -zxvf exabgp.tgz

RUN adduser -S exa \
    && mkdir /etc/exabgp \
    && mkfifo /run/exabgp.in \
    && mkfifo /run/exabgp.out \
    && chown exa /run/exabgp.in \
    && chown exa /run/exabgp.out \
    && chmod 600 /run/exabgp.in \
    && chmod 600 /run/exabgp.out

RUN echo "[exabgp.daemon]" > /opt/exabgp/etc/exabgp/exabgp.env \
    && echo "user = 'exa'" >> /opt/exabgp/etc/exabgp/exabgp.env

ENV PYTHONPATH=/opt/exabgp/lib
ENV PATH=$PATH:/opt/exabgp/sbin/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

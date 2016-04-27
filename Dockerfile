FROM xdrum/nginx-extras:stable

MAINTAINER Weiyan Shao "lighteningman@gmail.com"

WORKDIR /root

ENV DOCKER_GEN_VERSION 0.7.0

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/
ADD https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz /tmp/
ADD https://raw.githubusercontent.com/diafygi/acme-tiny/fcb7cd6f66e951eeae76ff2f48d8ad3e40da37ef/acme_tiny.py /bin/acme_tiny

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / &&\
    tar -C /bin -xzf /tmp/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
    rm /tmp/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
    rm /tmp/s6-overlay-amd64.tar.gz && \
    rm /etc/nginx/sites-enabled/default && \
    rm /etc/nginx/sites-available/default && \
    adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx && \
    apt-get update && \
    apt-get install -y python ruby2.0 cron && \
    apt-get clean && \
    ln -sf /usr/bin/ruby2.0 /usr/bin/ruby && \
    ln -sf /usr/bin/gem2.0 /usr/bin/gem && \
    rm -rf /var/lib/apt/lists/*

COPY ./fs_overlay /

RUN chmod a+x /bin/* && \
    chmod a+x /etc/cron.weekly/renew_certs

VOLUME /var/lib/https-portal

ENTRYPOINT ["/init"]

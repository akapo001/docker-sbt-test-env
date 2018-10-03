FROM docker:18.06.1-ce-dind

ENV JAVA_VERSION            8.171.11-r0
ENV SBT_VERSION             1.2.3
ENV DOCKER_COMPOSE_VERSION  1.22.0

COPY entrypoint.sh /usr/local/bin/

RUN set -eux; \
    apk update; \
    apk add --no-cache bash ca-certificates wget openjdk8=${JAVA_VERSION}; \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub 'https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub'; \
    wget -q -O /tmp/glibc.apk 'https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-2.28-r0.apk'; \
    wget -q -O /tmp/glibc-bin.apk 'https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-bin-2.28-r0.apk'; \
    apk add /tmp/glibc.apk /tmp/glibc-bin.apk; \
    rm /tmp/glibc.apk /tmp/glibc-bin.apk; \
    wget -q -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`"; \
    chmod +x /usr/local/bin/docker-compose; \
    wget -q -O /tmp/sbt.tgz "https://piccolo.link/sbt-${SBT_VERSION}.tgz"; \
    mkdir -p /opt; \
    tar -xzvf /tmp/sbt.tgz --directory=/opt; \
    chmod +x /usr/local/bin/entrypoint.sh;

ENV PATH $PATH:/opt/sbt/bin

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
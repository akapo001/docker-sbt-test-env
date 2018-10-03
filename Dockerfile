FROM docker:18.06.1-ce-dind

ENV JAVA_VERSION            8.171.11-r0
ENV SBT_VERSION             1.2.3
ENV DOCKER_COMPOSE_VERSION  1.22.0

RUN set -eux; \
    apk update; \
    apk add --no-cache curl; \
    apk add --no-cache bash openjdk8=${JAVA_VERSION}; \
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`" \
        -o /usr/local/bin/docker-compose; \
    chmod +x /usr/local/bin/docker-compose; \
    curl -L https://piccolo.link/sbt-${SBT_VERSION}.tgz \
        -o /tmp/sbt.tgz; \
    mkdir -p /opt; \
    tar -xzvf /tmp/sbt.tgz --directory=/opt;

ENV PATH $PATH:/opt/sbt/bin

ENTRYPOINT [ "/bin/bash" ]
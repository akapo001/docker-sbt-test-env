FROM centos:7

ARG JAVA_DIST_URL="https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b04/OpenJDK8U-jdk_x64_linux_hotspot_8u212b04.tar.gz"

ARG SBT_DIST_URL="https://piccolo.link/sbt-1.2.8.tgz"

ARG DOCKER_COMPOSE_VERSION="1.24.1"

ARG DOCKER_COMMIT="27471a8b93e980bd4c51464ee933ed90fd36bf97"
ARG DIND_COMMIT="37498f009d8bf25fbb6199e8ccd34bed84f2874b"

ENV JAVA_HOME               /opt/java-1.8-openjdk
ENV SBT_HOME                /opt/sbt
ENV PATH                    ${PATH}:${JAVA_HOME}/bin:${SBT_HOME}/bin

RUN set -eux; \
    yum install -y yum-utils device-mapper-persistent-data lvm2; \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo; \
    yum install -y docker-ce docker-ce-cli containerd.io; \
    mkdir --parents "${JAVA_HOME}" "${SBT_HOME}" /tmp/setup ;\
    curl --output /tmp/setup/openjdk.tar.gz --silent --show-error --location "${JAVA_DIST_URL}"; \
    tar -xf /tmp/setup/openjdk.tar.gz --directory="${JAVA_HOME}" --strip=1 ;\
    curl --output /tmp/setup/sbt.tgz --silent --show-error --location "${SBT_DIST_URL}"; \
    tar -xf /tmp/setup/sbt.tgz --directory="${SBT_HOME}" --strip=1 ;\
    curl --output /usr/local/bin/docker-compose --silent --show-error --location "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`"; \
    chmod +x /usr/local/bin/docker-compose; \
    curl --output /usr/local/bin/dind --silent --show-error --location "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind"; \
    chmod +x /usr/local/bin/dind; \
    curl --output /usr/local/bin/dockerd-entrypoint.sh --silent --show-error --location "https://raw.githubusercontent.com/docker-library/docker/${DOCKER_COMMIT}/dockerd-entrypoint.sh"; \
    chmod +x /usr/local/bin/dockerd-entrypoint.sh; \
    curl --output /usr/local/bin/modprobe --silent --show-error --location "https://raw.githubusercontent.com/docker-library/docker/${DOCKER_COMMIT}/modprobe.sh"; \
    chmod +x /usr/local/bin/modprobe; \
    groupadd --system dockremap; \
    useradd  --system -g dockremap dockremap; \
    echo 'dockremap:165536:65536' >> /etc/subuid; \
    echo 'dockremap:165536:65536' >> /etc/subgid; \
    \
    rm -rf /tmp/setup; \
    yum clean all; \
    rm -rf /var/cache/yum/*; \
    \
    docker  --version; \
    dockerd --version; \
    docker-compose --version; \
    java  -version; \
    javac -version; \
    sbt sbtVersion;

COPY entrypoint.sh /usr/local/bin/
RUN set -eux; \
    chmod +x /usr/local/bin/entrypoint.sh;

VOLUME /var/lib/docker
EXPOSE 2375

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD []

FROM debian:bullseye-slim

ARG GIT_BRANCH_OR_TAG=main

RUN mkdir /output /output/config /output/extension
COPY install-new-relic-extension.sh /
RUN set -ex && \
    apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends \
    curl openssl libpcre3-dev libzlcore-dev golang git wget \
    lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list && \
    wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    apt-get -q update && \
    git clone https://github.com/newrelic/newrelic-php-agent /tmp/newrelic-php-agent-repo && \
    cd /tmp/newrelic-php-agent-repo && \
    git checkout ${GIT_BRANCH_OR_TAG} || git checkout main && \
    cp agent/scripts/newrelic.ini.template /output/config/ && \
    /install-new-relic-extension.sh && \
    cp -r bin /output/bin && \
    rm -rf /tmp/newrelic-php-agent-repo && \
    apt-get -qy remove curl openssl libpcre3-dev libzlcore-dev golang git wget && \
    apt-get -qy autoremove && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

WORKDIR /output

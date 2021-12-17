FROM debian:bullseye-slim

RUN mkdir /output /output/config /output/extension /output/extension/7.4 /output/extension/8.0
RUN set -ex && \
    apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends \
    curl openssl libpcre3-dev libzlcore-dev golang git wget \
    lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list && \
    wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    apt-get -q update && \
    apt-get -qy install php7.4-dev php8.0-dev && \
    git clone https://github.com/newrelic/newrelic-php-agent /tmp/newrelic-php-agent-repo && \
    cd /tmp/newrelic-php-agent-repo && \
    cp agent/scripts/newrelic.ini.template /output/config/ && \
        make clean && \
            update-alternatives --set php /usr/bin/php7.4 && \
            update-alternatives --set phpize /usr/bin/phpize7.4 && \
            update-alternatives --set php-config /usr/bin/php-config7.4 && \
            make all && cp agent/modules/newrelic.so /output/extension/7.4/. && \
        make clean && \
            update-alternatives --set php /usr/bin/php8.0 && \
            update-alternatives --set phpize /usr/bin/phpize8.0 && \
            update-alternatives --set php-config /usr/bin/php-config8.0 && \
            make all && cp agent/modules/newrelic.so /output/extension/8.0/. && \
        cp -r bin /output/bin && \
        rm -rf /tmp/newrelic-php-agent-repo && \
    apt-get -qy remove curl openssl libpcre3-dev libzlcore-dev golang git wget php7.4-dev php8.0-dev && \
    apt-get -qy autoremove && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

WORKDIR /output

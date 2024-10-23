ARG PY_VERSION=3.10

# Base image used for all stages
FROM python:${PY_VERSION} as base

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
    && apt-get install -yq \
      iputils-ping \
      lsb-release \
      net-tools \
      postgresql \
      sendmail \
      snmp \
      tree \
      vim \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# stage for python dependencies
FROM base as python_dependencies

ARG PYTHONUNBUFFERED=1
ARG PIP_NO_CACHE_DIR=off
ARG PIP_NO_WARN_SCRIPT_LOCATION=0
ARG PIP_DISABLE_ROOT_WARNING=ignore
ARG PIP_DISABLE_PIP_VERSION_CHECK=1

COPY config/python_dependencies/requirements.txt /tmp/requirements.txt

RUN pip install --upgrade -r /tmp/requirements.txt 

# stage for yangsuite setup
FROM python_dependencies as app_setup

EXPOSE 80 443 3000 8080 8086 9339 50051 50052 57345 57344

ENV DOCKER_RUN=true

COPY config/build-assets/ /build-assets

RUN groupadd --gid 1000 developer \
    && useradd --create-home --home-dir /home/developer --no-user-group \
    --no-log-init --groups developer --shell /bin/bash developer \
    && echo 'alias ll="ls -al"' >> /root/.bashrc \
    && echo 'alias ll="ls -al"' >> /home/developer/.bashrc \
    && mkdir -p /ys-data \
    && mkdir -p /ys-static \
    && mkdir -p /var/run/uwsgi/ \
    && mkdir -p /home/developer/src \
    && chmod u+s /bin/ping \
    && chmod +x /build-assets/migrate_and_start.sh \
    && chmod +x /build-assets/start_environment.sh \
    && ln -snf /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime \
    && YS_DIR=$(pip show yangsuite | grep "^Location"|cut -d" " -f 2)/yangsuite \
    && echo ${CONTAINER_TIMEZONE} > /etc/timezone \
    && yangsuite \
    --save-settings \
    --configure-only \
    --data-path /ys-data \
    --static-root /ys-static \
    --allowed-hosts localhost \
    --settings yangsuite.settings.production \
    && chown -R developer:developer \
        /var/run/ \
        /var/log/ \
        /ys-data/ \
        /ys-static/ \
        /build-assets/ \
        ${YS_DIR}

USER developer

ENTRYPOINT ["/build-assets/start_environment.sh"]
CMD tail -f /dev/null 
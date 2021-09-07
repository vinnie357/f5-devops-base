# based on microsoft codespaces containers thank you!
# [Choice] Ubuntu version: bionic, focal
# https://hub.docker.com/_/ubuntu
ARG VARIANT="focal"

FROM ubuntu:${VARIANT}

ENV USERNAME="f5-devops" \
    USER_UID=1000 \
    USER_GID=1000 \
    PYTHON_VERSION="3.8" \
    GO_ROOT="/usr/local/go" \
    GO_PATH="/go" \
    GO_VERSION="1.17" \
    PRECOMMIT_VERSION="2.14.1"
# scripts
COPY scripts-library/ubuntu/* /tmp/scripts/
# base
RUN set -ex \
&& apt-get update && export DEBIAN_FRONTEND=noninteractive \
&& apt-get -y install --no-install-recommends \
sudo \
zsh \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
# user
RUN set -ex \
 && bash /tmp/scripts/create-user.sh ${USERNAME} ${USER_UID}  \
 && bash /tmp/scripts/setup-user.sh "${USERNAME}" "${PATH}"
# common packages
RUN bash /tmp/scripts/common-debian.sh "true" "${USERNAME}" "${USER_UID}" "${USER_GID}" "false" "true"

# pre-commit, go, docker
RUN set -ex \
    && bash /tmp/scripts/python-debian.sh ${PYTHON_VERSION} \
    && bash /tmp/scripts/pre-commit-debian.sh ${PRECOMMIT_VERSION} \
    && bash /tmp/scripts/docker-debian.sh "true" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "true" \
    && bash /tmp/scripts/golite-debian.sh "${GO_VERSION}" "${GO_ROOT}" "${GO_PATH}" "${USERNAME}" "true" "false" 
# Clean up
RUN set -ex \
&& apt-get autoremove -y && apt-get clean -y && rm -rf /tmp/scripts && rm -rf /var/lib/apt/lists/*

#change user
USER ${USERNAME}
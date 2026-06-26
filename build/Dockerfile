FROM node:24-slim AS base
WORKDIR /

# Install OS dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install git vim nano

RUN echo "mariadb-server mariadb-server/root_password password admin" | debconf-set-selections && \
    echo "mariadb-server mariadb-server/root_password_again password admin" | debconf-set-selections && \
    apt-get install -y mariadb-server

RUN usermod -l pv -d /home/pv -m node \
    && groupmod -n pv node

FROM base AS copy
USER pv
WORKDIR /home/pv
COPY --chown=pv:pv pv/ /home/pv/

FROM copy AS setup
USER root

# Set up the local database
RUN sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_unicode_520_ci/g' /home/pv/dump.sql \
    && service mariadb start \
    && mysql -u root -padmin -e "CREATE DATABASE localhost;" \
    && mysql -u root -padmin localhost < /home/pv/dump.sql

# Set up corepack and pnpm
ENV COREPACK_HOME=/tmp/corepack
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable

# Copy the environment variables into bashrc
RUN --mount=type=secret,id=env \
    awk '/^[A-Za-z_]/ {print "export " $0}' /run/secrets/env >> /home/pv/.bashrc

# Set up SSH authentication
USER pv
RUN mkdir -p .ssh \
    && chmod 700 .ssh \
    && ssh-keyscan github.com >> .ssh/known_hosts \
    && chmod 600 .ssh/known_hosts \
    && chmod 744 install.sh

# Install OS dependencies
FROM node:24-slim AS base
WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install git vim nano sudo mariadb-server sshpass

# Set up user
FROM base AS setup-user
RUN usermod -l pv -d /home/pv -m node \
    && groupmod -n pv node \
    && usermod -aG sudo pv \
    && echo "pv ALL=(ALL) NOPASSWD:ALL" >> etc/sudoers
USER pv
WORKDIR /home/pv

# Set up corepack and pnpm
ENV COREPACK_HOME=/tmp/corepack
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN sudo corepack enable

# Set up SSH authentication
RUN mkdir -p .ssh \
    && chmod 700 .ssh \
    && ssh-keyscan github.com >> .ssh/known_hosts \
    && chmod 600 .ssh/known_hosts

# Set up the local database
FROM setup-user AS setup-db
COPY --chown=pv:pv dump.sql /home/pv/dump.sql
RUN sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' /home/pv/dump.sql \
    && sudo service mariadb start \
    && sudo sed -i 's/^bind-address\s*=\s*.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf \
    && sudo mariadb -u root -padmin -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'admin'; CREATE USER 'root'@'%' IDENTIFIED BY 'admin'; GRANT ALL PRIVILEGES ON localhost.* TO 'root'@'%'; CREATE USER 'dev'@'%' IDENTIFIED BY 'admin'; GRANT ALL PRIVILEGES ON localhost.* TO 'dev'@'%'; FLUSH PRIVILEGES;" \
    && mariadb -u root -padmin -e "CREATE DATABASE localhost;" \
    && mariadb -u root -padmin localhost < /home/pv/dump.sql \
    && rm /home/pv/dump.sql

# Copy environment variables
FROM setup-db AS setup-env
RUN --mount=type=secret,id=env \
    sudo awk '/^[A-Za-z_]/ {print "export " $0}' /run/secrets/env >> /home/pv/env.sh
RUN chmod 744 env.sh

FROM node:24-slim AS base
WORKDIR /

# Install OS dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install git vim nano

# Set up corepack and pnpm
ENV COREPACK_HOME=/tmp/corepack
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable

RUN usermod -l pv -d /home/pv -m node \
    && groupmod -n pv node

FROM base AS copy
USER pv
WORKDIR /home/pv
COPY --chown=pv:pv pv/.ssh/ /home/pv/.ssh/
COPY --chown=pv:pv pv/.bashrc /home/pv/
COPY --chown=pv:pv pv/install.sh /home/pv/

FROM copy AS setup

# Copy the environment variables into bashrc
USER root
RUN --mount=type=secret,id=env \
    awk '/^[A-Za-z_]/ {print "export " $0}' /run/secrets/env >> /home/pv/.bashrc
USER pv

# Set up SSH authentication
RUN chmod 700 .ssh \
    && chmod 600 .ssh/id_pv \
    && chmod 644 .ssh/id_pv.pub \
    && ssh-keyscan github.com >> .ssh/known_hosts \
    && chmod 600 .ssh/known_hosts \
    && chmod 744 install.sh

# Clone down the repositories and stall indefinitely
CMD ["bash", "-c", "~/install.sh && tail -f /dev/null"]

# Use public or private image
ARG MODE=private
FROM ghcr.io/progressive-victory/the-local-setup:latest AS base-private
FROM ghcr.io/progressive-victory/the-local-setup-public:latest AS base-public
FROM base-${MODE} AS base

# Copy configuration scripts
USER pv
WORKDIR /home/pv
COPY --chown=pv:pv home/ /home/pv/
RUN chmod 744 .bashrc *.sh \
    && find /home/pv \( -name '*.sh' -o -name '.bashrc' -o -name '.gitconfig' \) -exec sed -i 's/\r$//' {} +

# Set up SSH keys
USER root
FROM base AS setup-ssh
RUN --mount=type=secret,id=ssh cp /run/secrets/ssh /home/pv/.ssh/id_pv
RUN --mount=type=secret,id=sshpub cp /run/secrets/sshpub /home/pv/.ssh/id_pv.pub
RUN chown pv /home/pv/.ssh/id_pv \
    && chown pv /home/pv/.ssh/id_pv.pub

USER pv
RUN chmod 600 /home/pv/.ssh/id_pv \
    && chmod 644 /home/pv/.ssh/id_pv.pub

ENV DEBIAN_FRONTEND=interactive

CMD ["bash", "-c", "~/install.sh && tail -f /dev/null"]

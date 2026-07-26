FROM ghcr.io/progressive-victory/the-local-setup:latest AS base
WORKDIR /home/pv
USER root

RUN sed -i 's/^bind-address\s*=\s*.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

ENV DEBIAN_FRONTEND=interactive

COPY --chown=pv:pv home/ /home/pv/

RUN --mount=type=secret,id=ssh cp /run/secrets/ssh /home/pv/.ssh/id_pv
RUN --mount=type=secret,id=sshpub cp /run/secrets/sshpub /home/pv/.ssh/id_pv.pub

RUN chown pv /home/pv/.ssh/id_pv \
    && chown pv /home/pv/.ssh/id_pv.pub

USER pv
RUN chmod 600 /home/pv/.ssh/id_pv \
    && chmod 644 /home/pv/.ssh/id_pv.pub \
    && chmod 744 install.sh \
    && find /home/pv \( -name '*.sh' -o -name '.bashrc' -o -name '.gitconfig' \) -exec sed -i 's/\r$//' {} +

CMD ["bash", "-c", "~/install.sh && tail -f /dev/null"]

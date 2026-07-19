FROM ghcr.io/progressive-victory/the-local-setup:latest AS base
WORKDIR /home/pv
USER root

ENV DEBIAN_FRONTEND=interactive

COPY --chown=pv:pv home/ /home/pv/

RUN --mount=type=secret,id=ssh cp /run/secrets/ssh /home/pv/.ssh/id_pv
RUN --mount=type=secret,id=sshpub cp /run/secrets/sshpub /home/pv/.ssh/id_pv.pub

RUN chown pv /home/pv/.ssh/id_pv \
    && chown pv /home/pv/.ssh/id_pv.pub

USER pv
RUN chmod 600 /home/pv/.ssh/id_pv \
    && chmod 644 /home/pv/.ssh/id_pv.pub \
    && chmod 744 install.sh

CMD ["bash", "-c", "find ~ -maxdepth 2 \\( -name '*.sh' -o -name '*.conf' -o -name '*.yaml' -o -name '*.yml' -o -name '.bashrc' -o -name '.gitconfig' \\) -exec sed -i 's/\\r$//' {} + ; ~/install.sh && tail -f /dev/null"]

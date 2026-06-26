FROM ghcr.io/progressive-victory/the-local-setup:latest AS base
WORKDIR /home/pv

USER root
RUN --mount=type=secret,id=ssh cp /run/secrets/ssh .ssh/id_pv
RUN --mount=type=secret,id=sshpub cp /run/secrets/sshpub .ssh/id_pv.pub

RUN chown pv .ssh/id_pv \
    && chown pv .ssh/id_pv.pub

USER pv
RUN chmod 600 .ssh/id_pv \
    && chmod 644 .ssh/id_pv.pub

CMD ["bash", "-c", "~/install.sh && tail -f /dev/null"]

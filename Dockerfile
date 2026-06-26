FROM ghcr.io/Progressive-Victory/the-local-setup:latest AS base
USER pv
WORKDIR /home/pv

RUN --mount=type=secret,id=ssh cp /run/secrets/ssh ~/.ssh/id_pv
RUN --mount=type=secret,id=sshpub cp /run/secrets/sshpub ~/.ssh/id_pv.pub

CMD ["bash", "-c", "~/install.sh && tail -f /dev/null"]

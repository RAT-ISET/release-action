FROM rockylinux:9
LABEL authors="Rangeset"

ARG OUT_PATH

CMD ["/bin/bash"]

RUN dnf install -y rpm-build cmake gcc gnupg2 && \
    useradd -m builder

USER builder
WORKDIR /home/builder

COPY --chown=builder:builder ./ ./
COPY --chown=builder:builder ./tmp/pkg.sh ./

RUN bash pkg.sh

RUN --mount=type=secret,id=gpg_key \
    cat /run/secrets/gpg_key > /tmp/private.key && \
    gpg --import /tmp/private.key && \
    rm /tmp/private.key

FROM scratch AS exporter
COPY --from=0 ${OUT_PATH}/*.rpm /

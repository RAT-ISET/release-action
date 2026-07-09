FROM fedora:latest
LABEL authors="Rangeset"

ARG VERSION_FULL

CMD ["/bin/bash"]

RUN dnf install -y rpm-build rpm-sign cmake gcc gcc-c++ gnupg2 git && \
    useradd -m builder

USER builder
WORKDIR /home/builder

COPY --chown=builder:builder ./ ./
COPY --chown=builder:builder ./tmp/pkg.sh ./

RUN FULL_VERSION=${FULL_VERSION} bash pkg.sh

USER root
WORKDIR /home/builder/out/dist/

RUN --mount=type=secret,id=gpg_key \
    --mount=type=secret,id=gpg_key_id \
    cat /run/secrets/gpg_key | base64 -d > /tmp/private.key && \
    wc -c /tmp/private.key && \
    gpg --batch --import /tmp/private.key && \
    rm /tmp/private.key && \
    GPG_KEY_ID=$(cat /run/secrets/gpg_key_id) && \
    rpmsign --addsign --define "_gpg_name $GPG_KEY_ID" *.rpm

FROM scratch AS exporter
COPY --from=0 /home/builder/out/dist/*.rpm /

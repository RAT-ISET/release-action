FROM fedora:latest
LABEL authors="Rangeset"

ARG OUT_PATH
ARG GPG_KEY_ID

CMD ["/bin/bash"]

RUN dnf install -y rpm-build cmake gcc gcc-c++ gnupg2 git && \
    useradd -m builder

USER builder
WORKDIR /home/builder

COPY --chown=builder:builder ./ ./
COPY --chown=builder:builder ./tmp/pkg.sh ./

RUN bash pkg.sh

USER root
WORKDIR /home/builder/out/dist/

RUN --mount=type=secret,id=gpg_key \
    cat /run/secrets/gpg_key | base64 -d > /tmp/private.key && \
    gpg --batch --import /tmp/private.key && \
    rm /tmp/private.key && \
    rpm --addsign --define "_gpg_name ${KEY_ID}" *.rpm

FROM scratch AS exporter
COPY --from=0 *.rpm /

FROM rockylinux:latest
LABEL authors="Rangeset"

ARG GPG_KEY
ARG OUT_PATH
ARG SOURCE_PATH

CMD ["/bin/bash"]

RUN dnf install -y rpm-build cmake gcc gnupg2 && \
    useradd -m builder

USER builder
WORKDIR /home/builder

COPY --chown=builder:builder ${SOURCE_PATH}/ ./
COPY --chown=builder:builder ./pkg.sh ./

RUN GPG_KEY=${GPG_KEY} OUT_PATH=${OUT_PATH} bash

FROM scratch AS exporter
COPY --from=0 ${OUT_PATH}/*.rpm /

FROM archlinux:latest
LABEL authors="Rangeset"

ARG ARCH_REPOS_PATH
ARG SOFTWARE_NAME

CMD ["/bin/bash"]

RUN pacman -Syu --noconfirm pacman-contrib tree

RUN --mount=type=secret,id=gpg_key \
    --mount=type=secret,id=gpg_key_id \
    --mount=target=/src \
    tree /src && \
    mkdir -p work && cp -a /src/arch/. work/ && \
    cat /run/secrets/gpg_key | base64 -d > /tmp/private.key && \
    wc -c /tmp/private.key && \
    gpg --batch --import /tmp/private.key && \
    rm /tmp/private.key && \
    GPG_KEY_ID=$(cat /run/secrets/gpg_key_id) && \
    tree work && \
    rm -rf work/${ARCH_REPOS_PATH}/${SOFTWARE_NAME}/* && \
    cp -a /src/incoming/arch/. work/ && \
    cd work/${ARCH_REPOS_PATH} && \
    repo-add isetrepo.db.tar.zst $(find . -name "*.pkg.tar.zst") && \
    find . -name "*.pkg.tar.zst" -exec gpg --detach-sign {} \;

FROM scratch AS exporter
COPY --from=0 ./work/* /

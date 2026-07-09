FROM fedora:latest
LABEL authors="Rangeset"

ARG RPM_REPOS_PATH

CMD ["/bin/bash"]

RUN dnf install -y git createrepo_c

RUN --mount=type=secret,id=gpg_key \
    --mount=type=secret,id=gpg_key_id \
    --mount=target=/src \
    mkdir work && \
    cp -a /src/rpm/. work/ && \
    cp -a /src/incoming/rpm/. work/ && \
    createrepo_c --update work/${RPM_REPOS_PATH} && \
    cat /run/secrets/gpg_key | base64 -d > /tmp/private.key && \
    wc -c /tmp/private.key && \
    gpg --batch --import /tmp/private.key && \
    rm /tmp/private.key && \
    GPG_KEY_ID=$(cat /run/secrets/gpg_key_id) && \
    gpg --detach-sign \
        --armor --batch --yes \
        -u ${GPG_KEY_ID} \
        -o work/${RPM_REPOS_PATH}/repodata/repomd.xml.asc \
        work/${RPM_REPOS_PATH}/repodata/repomd.xml

FROM scratch AS exporter
COPY --from=0 ./work/* /

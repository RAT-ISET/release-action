FROM fedora:latest
LABEL authors="Rangeset"

ARG RPM_REPOS_PATH

CMD ["/bin/bash"]

RUN dnf install -y git createrepo_c && useradd -m builder

RUN --mount=type=secret,id=gpg_key \
    --mount=type=secret,id=gpg_key_id \
    --mount=target=/src,rw \
    cp -a /src/incoming/rpm/* /src/rpm/ && \
    createrepo_c --update /src/rpm/${RPM_REPOS_PATH} \
    cat /run/secrets/gpg_key | base64 -d > /tmp/private.key && \
    wc -c /tmp/private.key && \
    gpg --batch --import /tmp/private.key && \
    rm /tmp/private.key && \
    GPG_KEY_ID=$(cat /run/secrets/gpg_key_id) && \
    gpg --detach-sign \
        --armor --batch --yes \
        -u ${GPG_KEY_ID} \
        -o /src/rpm/${RPM_REPOS_PATH}/repodata/repomd.xml.asc \
        /src/rpm/${RPM_REPOS_PATH}/repodata/repomd.xml

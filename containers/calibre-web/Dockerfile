ARG VERSION

FROM lscr.io/linuxserver/calibre-web:${VERSION}
LABEL org.opencontainers.image.source https://github.com/apetresc/homelab

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install pcregrep && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/* /var/tmp/*

COPY scripts/add-ebook /usr/local/bin/add-ebook
COPY scripts/set-cover /usr/local/bin/set-cover

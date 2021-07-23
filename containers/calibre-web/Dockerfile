FROM linuxserver/calibre-web:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install pcregrep && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/* /var/tmp/*

COPY scripts/add-ebook /usr/local/bin/add-ebook

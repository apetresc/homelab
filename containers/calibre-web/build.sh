#!/bin/bash -ex

VERSION="$1"

docker build --build-arg VERSION=$VERSION -t ghcr.io/apetresc/calibre-web:$VERSION .
docker push ghcr.io/apetresc/calibre-web:$VERSION

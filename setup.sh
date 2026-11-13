#!/usr/bin/env bash
#
# Adminer setup helper.
#
# Usage:
#   ./setup.sh            ensure .env + adminer.php exist, then start server
#   ./setup.sh download   (re)download adminer.php
#   ./setup.sh update     alias for download
#
# ADMINER_VERSION in .env controls which version is fetched
# ("latest" or a specific release like 6.0.0).

set -euo pipefail
cd "$(dirname "$0")"

VERSION="${ADMINER_VERSION:-latest}"
if [ -f .env ]; then
    V=$(grep -E '^ADMINER_VERSION=' .env | tail -1 | cut -d= -f2- | tr -d '"'"'"' \r')
    [ -n "$V" ] && VERSION="$V"
fi

download() {
    if [ "$VERSION" = "latest" ]; then
        url="https://www.adminer.org/latest.php"
    else
        url="https://github.com/vrana/adminer/releases/download/v${VERSION}/adminer-${VERSION}.php"
    fi
    echo ">> Downloading Adminer $VERSION"
    curl -fSL "$url" -o adminer.php
    echo ">> Saved adminer.php"
}

start() {
    if [ ! -f .env ]; then
        cp .env.example .env
        echo ">> Created .env from .env.example - edit it to taste"
    fi
    if [ ! -f adminer.php ]; then
        download
    fi
    if ! php -m | grep -qi '^mysqli$'; then
        echo ">> Warning: PHP mysqli extension not found (needed for MySQL/MariaDB)"
    fi
    echo ">> Adminer: http://127.0.0.1:8080"
    php -S 127.0.0.1:8080
}

case "${1:-start}" in
    start)    start ;;
    download) download ;;
    update)   download ;;
    *)        echo "usage: $0 [start|download|update]"; exit 1 ;;
esac

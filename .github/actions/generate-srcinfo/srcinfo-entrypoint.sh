#!/usr/bin/env bash
set -euxo pipefail

SRCINFO=$(makepkg --printsrcinfo)
VERSION=$(echo "${SRCINFO}" | grep "pkgver" | cut -f2 -d '=' | xargs)
echo ::set-output name=srcinfo::"${SRCINFO}"
echo ::set-output name=version::"${VERSION}"

#!/usr/bin/env bash
set -euxo pipefail

cd /home/builduser
cat PKGBUILD
SRCINFO=$(makepkg --printsrcinfo)
VERSION=$(echo "${SRCINFO}" | grep "pkgver" | cut -f2 -d '=' | xargs)
# Escape multiline strings, see:
# https://github.community/t5/GitHub-Actions/set-output-Truncates-Multiline-Strings/m-p/37870
SRCINFO="${SRCINFO//'%'/'%25'}"
SRCINFO="${SRCINFO//$'\n'/'%0A'}"
SRCINFO="${SRCINFO//$'\r'/'%0D'}"
echo ::set-output name=srcinfo::"${SRCINFO}"
echo ::set-output name=version::"${VERSION}"

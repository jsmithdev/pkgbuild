#!/usr/bin/env bash
set -euxo pipefail

cd /home/builduser/package
makepkg --noconfirm -si
SRC_VERSION=$(grep "pkgver" .SRCINFO | cut -f2 -d '=' | xargs)
INSTALLED_VERSION=$(sfdx --version | cut -f1 -d' ' | cut -f 2 -d '/')

if [ "$SRC_VERSION" != "${INSTALLED_VERSION/-/_}" ]; then
  exit 1
fi
#!/usr/bin/env bash
set -euxo pipefail

cd /home/builduser/package
makepkg --noconfirm -si
SRC_VERSION=$(grep "pkgver" .SRCINFO | cut -f2 -d '=' | xargs)
INSTALLED_VERSION=$(sfdx --version | cut -f1 -d' ' | cut -f 2 -d '/')

if [ "$SRC_VERSION" != "$INSTALLED_VERSION" ]; then
  exit 1
fi

# There is no information on which version of `sf` that comes bundled with
# sfdx, so we are just going to assume that as long as `sf` was installed,
# the installation was successful
sf --version

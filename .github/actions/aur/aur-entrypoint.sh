#!/bin/sh
set -eux

git clone ssh://aur@aur.archlinux.org/sfdx-cli.git /git/sfdx-cli
cd /git/sfdx-cli
cp /PKGBUILD .
cp /.SRCINFO .
VERSION=$(grep "pkgver" .SRCINFO | cut -f2 -d '=' | xargs)
if [ -n "$(git status -s)" ]; then
  git diff --no-pager
  git add .
  git config user.name "Dang Mai"
  git config user.email "contact@dangmai.net"
  git commit -m "Updated to ${VERSION}"
  #git push origin master
fi

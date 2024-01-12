#!/bin/sh
set -eux

git clone ssh://aur@aur.archlinux.org/sf-cli.git /git/sf-cli
cd /git/sf-cli
cp /PKGBUILD .
cp /.SRCINFO .
VERSION=$(grep "pkgver" .SRCINFO | cut -f2 -d '=' | xargs)
if [ -n "$(git status -s)" ]; then
  git --no-pager diff
  git add .
  git config user.name "Jamie Smith"
  git config user.email "aur@jsmith.dev"
  git commit -m "Updated to ${VERSION}"
  git push origin master
fi

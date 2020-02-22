#!/usr/bin/env bash
set -euxo pipefail

git clone ssh://aur@aur.archlinux.org/sfdx-cli.git /git/sfdx-cli
cd /git/sfdx-cli
touch test.txt
if [[ -n $(git status -s) ]]; then
  git add .
  git config user.name "Dang Mai"
  git config user.email "contact@dangmai.net"
  git commit -m "Test commit"
  #git commit -m "Updated to ${version}"
  #git push origin master
fi

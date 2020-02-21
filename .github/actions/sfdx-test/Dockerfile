FROM dangmai/archlinux-devel:latest

RUN mkdir -p package
COPY sfdx-entrypoint.sh sfdx-entrypoint.sh
COPY sfdx-cli/.SRCINFO package/.SRCINFO
COPY sfdx-cli/PKGBUILD package/PKGBUILD

ENTRYPOINT ["/home/builduser/sfdx-entrypoint.sh"]
FROM dangmai/archlinux-devel:latest

RUN mkdir -p package
COPY srcinfo-entrypoint.sh srcinfo-entrypoint.sh
COPY PKGBUILD PKGBUILD

ENTRYPOINT ["/home/builduser/srcinfo-entrypoint.sh"]
FROM archlinux:latest

RUN useradd builduser -m \
  && passwd -d builduser \
  && printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers # Allow the builduser passwordless sudo
RUN pacman --noconfirm -Syu base-devel
USER builduser

WORKDIR /home/builduser
RUN mkdir -p package
COPY scripts/sfdx-entrypoint.sh sfdx-entrypoint.sh
COPY sfdx-cli/.SRCINFO package/.SRCINFO
COPY sfdx-cli/PKGBUILD package/PKGBUILD

ENTRYPOINT ["./sfdx-entrypoint.sh"]
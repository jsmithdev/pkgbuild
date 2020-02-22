FROM alpine/git:latest

RUN mkdir -p /root/.ssh
COPY id_rsa /root/.ssh/id_rsa
COPY known_hosts /root/.ssh/known_hosts
COPY aur-entrypoint.sh /aur-entrypoint.sh

ENTRYPOINT ["/aur-entrypoint.sh"]
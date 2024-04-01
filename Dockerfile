#FROM <<BASECONTAINER>>
ARG ARCH=
FROM ${ARCH}/perl:slim-bullseye

MAINTAINER docker@intrepid.de

# based on https://github.com/WalterS/docker-squeezeboxserver
# with updates from:
#   https://github.com/twobaker/squeezeboxserver
#   https://github.com/McSlow/docker-squeezeboxserver
#   https://www.gitmemory.com/issue/Logitech/slimserver/436/706750404

ENV DEBIAN_FRONTEND=noninteractive

ARG PACKAGE_VERSION_URL ENV PACKAGE_VERSION_URL=${PACKAGE_VERSION_URL:"https://downloads.lms-community.org/LogitechMediaServer_v8.5.0/logitechmediaserver_8.5.0_all.deb"}
ARG SQUEEZE_UID="8888"
ENV SQUEEZE_BASE="/mnt/state"

ENV LC_ALL="C.UTF-8"
ENV LANG="de_DE.UTF-8"
ENV LANGUAGE="de_DE.UTF-8"

COPY ./bin/run.sh /

RUN passwd -l root ; \
    apt-get update && \
    apt-get -qy upgrade && \
    apt-get -qy install \
      locales \
      curl \
      wget \
      ca-certificates \
      flac \
      faad \
      lame \
      sox \
      ffmpeg \
      avahi-utils \
      opus-tools \
      libio-socket-ssl-perl \
      libwww-perl \
      libfont-freetype-perl \
      libcrypt-openssl-rsa-perl \
      libio-socket-inet6-perl \
      libcrypt-openssl-bignum-perl \
      libcrypt-openssl-random-perl \
      libsox-fmt-all \
      libio-socket-ssl-perl \
      libcrypt-ssleay-perl \
      libcrypt-openssl-random-perl && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure locales && \
    update-locale LANG=${LANG} && \
    URL=$(curl "${PACKAGE_VERSION_URL}") && \
    curl -Lsf -o /tmp/logitechmediaserver.deb "${URL}" && \
    dpkg -i /tmp/logitechmediaserver.deb && \
    rm -f /tmp/logitechmediaserver.deb && \
    sed -i s/"squeezeboxserver:x:103"/"squeezeboxserver:x:${SQUEEZE_UID}"/ /etc/passwd && \
    mkdir -p /mnt/state/log /mnt/state/cache /mnt/state/prefs /mnt/state/playlists /mnt/music && \
    chown squeezeboxserver:nogroup /usr/share/perl5/Slim /var/lib/squeezeboxserver /var/log/squeezeboxserver /mnt/state /etc/squeezeboxserver -R && \
    chmod 755 /run.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /etc/default/logitechmediaserver

COPY ./etc/logitechmediaserver /etc/default/logitechmediaserver

EXPOSE 3483 9000 9090

CMD /run.sh

HEALTHCHECK --start-period=30s --interval=30s --timeout=5s --retries=3 \
  CMD curl --silent --fail http://localhost:9000 || exit 1


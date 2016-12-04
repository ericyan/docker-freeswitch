FROM debian:jessie
MAINTAINER Eric Yan "docker@ericyan.me"

# Set locale to "en_US.UTF-8"
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install gosu for easy step-down from root
ENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget

# Install FreeSWITCH
ENV FREESWITCH_MAJOR 1.6
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-key D76EDC7725E010CF \
    && echo "deb http://files.freeswitch.org/repo/deb/freeswitch-$FREESWITCH_MAJOR/ jessie main" > /etc/apt/sources.list.d/freeswitch.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y freeswitch \
    freeswitch-mod-commands \
    freeswitch-mod-event-socket \
    freeswitch-mod-sofia \
    freeswitch-mod-dialplan-xml \
    freeswitch-mod-dptools \
    && rm -rf /var/lib/apt/lists/*

# Prepare configurations
COPY conf /etc/freeswitch/
RUN chown -R freeswitch:freeswitch /etc/freeswitch

# Local and public IP address (defaults to autodectection)
ENV LOCAL_IP_ADDR \$\${local_ip_v4}
ENV PUBLIC_IP_ADDR \$\${local_ip_v4}

# Expose SIP and RTP ports
ENV INTERNAL_SIP_PORT 5060
ENV EXTERNAL_SIP_PORT 5080
ENV RTP_START_PORT 64000
ENV RTP_END_PORT 65000
ENV EVENT_SOCKET_PORT 8021
EXPOSE $INTERNAL_SIP_PORT/tcp $INTERNAL_SIP_PORT/udp
EXPOSE $EXTERNAL_SIP_PORT/tcp $EXTERNAL_SIP_PORT/udp
EXPOSE $RTP_START_PORT-$RTP_END_PORT/udp

# Set up entrypoint
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]

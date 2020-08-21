FROM debian:buster-slim
LABEL maintainer "Eric Yan <docker@ericyan.me>"

# Install GnuPG
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg

# Install FreeSWITCH
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-key BD3189F5A2B57698 \
    && echo "deb http://files.freeswitch.org/repo/deb/debian-release/ buster main" \
        > /etc/apt/sources.list.d/freeswitch.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gettext-base \
        libcap2-bin \
        freeswitch \
        freeswitch-mod-commands \
        freeswitch-mod-event-socket \
        freeswitch-mod-sofia \
        freeswitch-mod-dialplan-xml \
        freeswitch-mod-dptools \
    && rm -rf /var/lib/apt/lists/*

# Prepare configurations
COPY conf /etc/freeswitch/

# Default settings
ENV LOCAL_IP_ADDR=\$\${local_ip_v4} \
    PUBLIC_IP_ADDR=\$\${local_ip_v4} \
    EVENT_SOCKET_IP_ADDR=127.0.0.1 \
    EVENT_SOCKET_ACL=loopback.auto \
    EVENT_SOCKET_PASSWORD=ClueCon \
    INTERNAL_SIP_PORT=5060 \
    EXTERNAL_SIP_PORT=5080 \
    RTP_START_PORT=64000 \
    RTP_END_PORT=65000 \
    EVENT_SOCKET_PORT=8021

# Expose SIP and RTP ports
EXPOSE $INTERNAL_SIP_PORT/tcp \
       $INTERNAL_SIP_PORT/udp \
       $EXTERNAL_SIP_PORT/tcp \
       $EXTERNAL_SIP_PORT/udp \
       $RTP_START_PORT-$RTP_END_PORT/udp

# Set up entrypoint
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]

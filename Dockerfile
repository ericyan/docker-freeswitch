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
ENV SIP_PORT=5060 \
    RTP_START_PORT=16384 \
    RTP_END_PORT=32768 \
    EVENT_SOCKET_PASSWORD=ClueCon

# Set up entrypoint
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]

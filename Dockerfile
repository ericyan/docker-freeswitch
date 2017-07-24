FROM ericyan/rust as builder

ARG mod_prometheus_tag=master
RUN curl -sSLf https://github.com/ericyan/mod_prometheus/archive/$mod_prometheus_tag.tar.gz \
    | tar --strip-components=1 -zxf - \
    && cargo build --release

FROM debian:jessie-slim
LABEL maintainer "Eric Yan <docker@ericyan.me>"

# Install FreeSWITCH
ENV FS_MAJOR=1.6
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-key D76EDC7725E010CF \
    && echo "deb http://files.freeswitch.org/repo/deb/freeswitch-$FS_MAJOR/ jessie main" \
        > /etc/apt/sources.list.d/freeswitch.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gettext-base \
        freeswitch \
        freeswitch-mod-commands \
        freeswitch-mod-event-socket \
        freeswitch-mod-sofia \
        freeswitch-mod-dialplan-xml \
        freeswitch-mod-dptools \
    && rm -rf /var/lib/apt/lists/*

# Add custom built modules
COPY --from=builder /rust/target/release/libmod_prometheus.so /usr/lib/freeswitch/mod/mod_prometheus.so

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
       $RTP_START_PORT-$RTP_END_PORT/udp \
       9282/tcp

# Set up entrypoint
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]

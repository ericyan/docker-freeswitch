# docker-freeswitch

Docker image for [FreeSWITCH](https://freeswitch.org/). With handpicked modules
and minimal configurations, this image is not very useful on its own, as it is
meant to be the base image for other FreeSWITCH-based containers.

## Getting started

### Build the image

Clone this repository and build an image locally:

```
$ docker build -t ericyan/freeswitch .
```

### Run FreeSWITCH in a container

```
$ docker run -d --net=host --cap-add SYS_NICE --name <contaner_name> ericyan/freeswitch
```

We are using `--net=host` here, as mapping a large port range can eat a lot of
memory (Docker issue [#11185](https://github.com/docker/docker/issues/11185)).

The `--cap-add SYS_NICE` is necessary to allow FreeSWITCH to adjust scheduling
priority (issue [#5](https://github.com/ericyan/docker-freeswitch/issues/5)).

You may override ports by setting environment variables with one or more `-e`
flags. For example, adding flag `-e "INTERNAL_SIP_PORT=9060"` will change the
SIP port of internal profile. Refer to `Dockerfile` for other options.

### Working with the container

To access the FreeSWITCH CLI:

```
$ docker exec -it <container_name> fs_cli -P <event_socket_port>
```

If you have changed the event socket port, then you must specify the new port
number using the `-P` flag.

## Modules

This image comes with a limited set of preinstalled modules:

 * mod_commands
 * mod_event-socket
 * mod_sofia
 * mod_dialplan-xml
 * mod_dptools

## Security considerations

This image is designed to be deployed on a private network. By default, clients
on LAN are able to make calls without authentication. So if you are planning to
put it on a public-facing network, do make sure that appropriate hardening is in
place.

See also: https://freeswitch.org/confluence/display/FREESWITCH/Security

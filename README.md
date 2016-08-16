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
$ docker run -d --net=host --name <contaner_name> ericyan/freeswitch
```

We are using `--net=host` here, as mapping a large port range can eat a lot of
memory (Docker issue [#11185](https://github.com/docker/docker/issues/11185)).

### Working with the container

To access the FreeSWITCH CLI:

```
$ docker exec -it <container_name> fs_cli
```

## Security considerations

This image is designed to be deployed on a private network. By default, clients
on LAN are able to make calls without authentication. So if you are planning to
put it on a public-facing network, do make sure that appropriate hardening is in
place.

See also: https://freeswitch.org/confluence/display/FREESWITCH/Security

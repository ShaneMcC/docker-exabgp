# exabgp-docker

This is a very simple docker image that just contains the latest version of exabgp.

It runs as the `exa` user (uid: 100) inside the container.

This image is currently built as an alpine image, which seems to work fine.

On startup, the file `/scripts/init.sh` will be run which will allow installing additional packages etc if needed for health-checks.

Example usage:

```
docker run --name exabgp -it -v /etc/exabgp:/etc/exabgp --network=host --rm ghcr.io/shanemcc/docker-exabgp:v4.2.22 /etc/exabgp/exabgp.conf
```

(This assumes you have a valid `exabgp.conf` in `/etc/exabgp/exabgp.conf` on the host)

# Fixing permission on Docker socket
if [ ! -z $DOCKERSOCK_OK ]; then
  DOCKERSOCK_USER=`stat -c "%u" /var/run/docker.sock`
  DOCKERSOCK_GROUP=`stat -c "%g" /var/run/docker.sock`
  if [ "$DOCKERSOCK_GROUP" != "1000" ] && [ "$DOCKERSOCK_GROUP" != "102" ] && [ "$DOCKERSOCK_GROUP" != "976" ]; then
    echo "Docker socket not owned by group IDs 1000, 102 or 976, changing its group to `id -g`"
    sudo chown $DOCKERSOCK_USER:`id -g` /var/run/docker.sock
    sudo chmod 770 /var/run/docker.sock
  fi
fi

if [ ! -z $DOCKERSOCK_OK ]; then
  echo "Docker server `docker version --format {{.Server.Version}}` | client `docker version --format {{.Client.Version}}`"
  echo "Docker-Compose `docker-compose version --short`"
  alias alpine='docker run -it --rm alpine:3.12'
  alias dive='docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive'
fi
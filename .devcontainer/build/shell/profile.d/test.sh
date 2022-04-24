# SSH key check
test -f ~/.ssh/id_rsa
[ "$?" = 0 ] && SSHRSA_OK=yes
[ -z $SSHRSA_OK ] && >&2 echo "⚠️  No id_rsa SSH private key found, SSH functionalities might not work"

# Timezone check
[ -z $TZ ] && >&2 echo "⚠️  TZ environment variable not set, time might be wrong!"

# Docker check
test -S /var/run/docker.sock
[ "$?" = 0 ] && DOCKERSOCK_OK=yes
[ -z $DOCKERSOCK_OK ] && >&2 echo "⚠️  Docker socket not found, docker will not be available"
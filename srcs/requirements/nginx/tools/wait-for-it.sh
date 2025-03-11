#!/bin/bash

# Wait for a service to be available on a specific host and port
# Usage: wait-for-it.sh <host>:<port> -- <command>

host=$(echo $1 | cut -d ':' -f 1)
port=$(echo $1 | cut -d ':' -f 2)
shift
cmd="$@"

until nc -z $host $port; do
  echo "Waiting for $host:$port to be available..."
  sleep 10
done

echo "$host:$port is available. Proceeding to start NGINX."
exec $cmd

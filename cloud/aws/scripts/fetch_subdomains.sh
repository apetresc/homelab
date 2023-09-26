#!/usr/bin/env bash
set -ex

declare -A service_subdomain_map
service_ids=$(docker service ls -q)
all_labels=$(docker service inspect $service_ids --format '{{json .Spec.Labels}} {{.Spec.Name}}')

IFS=$'\n'
echo "{"
first=1
for line in $all_labels; do
  labels=$(echo "$line" | awk '{$NF=""; print $0}')
  service_name=$(echo "$line" | awk '{print $NF}')

  if echo "$labels" | grep -q "traefik.http.routers.*.rule" && \
     echo "$labels" | grep -q "\"traefik.http.routers.*.tls.domains\[0\].main\":\"apetre.sc\""; then
    rule=$(echo $labels | grep -o 'Host(`[^`]*`)' | sed 's/Host(`\([^`]*\)`)/\1/')
    [[ -z $first ]] && echo -n ","
    echo -n "\"${service_name}_subdomain\": \"${rule}\""
    unset first
  fi
done
echo "}"


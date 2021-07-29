#!/bin/bash

service_name="backup-all-secrets"
secret_list=( `docker secret ls --format "{{ .Name }}"` )

cmd="docker service create \
  --name $service_name"

for secret in "${secret_list[@]}"
do
  cmd=$cmd" --secret ${secret}"
done

cmd=$cmd" nginx"
echo $cmd
$cmd

tar_file="backup_`date +\"%Y%m%d-%H%M%S\"`.tar"
container_id=`docker ps -f "label=com.docker.swarm.service.name=$service_name" -q`

echo $tar_file
echo $container_id

docker exec -w /usr/local $container_id sh -c "tar -cvf $tar_file -C /run/secrets ."

docker cp $container_id:/usr/local/$tar_file .

docker service rm $service_name

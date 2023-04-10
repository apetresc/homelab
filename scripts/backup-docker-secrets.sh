#!/bin/bash -ex

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

# Wait for the service to be deployed
while [ "$(docker service ps --format "{{ .CurrentState }}" --filter desired-state=running $service_name)" | grep -q "Running" ]; do
  sleep 1
done
sleep 10

tar_file="backup_`date +\"%Y%m%d-%H%M%S\"`.tar"
service_info=`docker service ps --format "{{ .Node }} {{ .ID }}" --filter desired-state=running $service_name`
node_name=`echo $service_info | awk '{print $1}'`
task_id=`echo $service_info | awk '{print $2}'`
node_address=`docker node inspect --format "{{ .Status.Addr }}" $node_name`
container_id=$(docker inspect --format '{{.Status.ContainerStatus.ContainerID}}' $task_id)

echo $tar_file
echo $node_name

docker -H $node_address exec -w /usr/local $container_id sh -c "tar -cvf $tar_file -C /run/secrets ."

docker -H $node_address cp $container_id:/usr/local/$tar_file .

docker service rm $service_name

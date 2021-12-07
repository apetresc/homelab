#!/bin/bash -ex

SYNAPSE_CONTAINER=$(docker ps -q --filter=name='matrix_synapse')
DB_CONTAINER=$(docker ps -q --filter=name='matrix_db')
SYNAPSE_PASSWORD=$(docker exec $DB_CONTAINER cat /var/run/secrets/synapse_postgres_password)

# Get a list of room_ids with an excessive number of state changes
docker exec $DB_CONTAINER psql synapse synapse -t -A -F"," -c "SELECT * FROM (SELECT room_id, count(*) AS count FROM state_groups_state GROUP BY room_id ORDER BY count DESC) t WHERE t.count > 100000;" > cleanup.csv
docker exec $SYNAPSE_CONTAINER curl -L "https://github.com/matrix-org/rust-synapse-compress-state/releases/download/v0.1.0/synapse-compress-state_x86_64-unknown-linux" --output /usr/local/bin/synapse_compress_state
docker exec $SYNAPSE_CONTAINER chmod +x /usr/local/bin/synapse_compress_state

for room_id in $(cat cleanup.csv | cut -d',' -f1)
do
  docker exec $SYNAPSE_CONTAINER /usr/local/bin/synapse_compress_state -t -o /tmp/state-compressor.sql -p "host=db user=synapse password=$SYNAPSE_PASSWORD dbname=synapse" -r $room_id
  docker cp $SYNAPSE_CONTAINER:/tmp/state-compressor.sql state-compressor.sql
  docker exec -i $DB_CONTAINER psql synapse synapse < state-compressor.sql
done

docker service scale matrix_synapse=0

docker exec $DB_CONTAINER psql synapse synapse -c 'REINDEX (VERBOSE) DATABASE synapse;'
docker exec $DB_CONTAINER psql synapse synapse -c 'VACUUM FULL VERBOSE;'

docker service scale matrix_synapse=1

rm cleanup.csv
rm state-compressor.sql

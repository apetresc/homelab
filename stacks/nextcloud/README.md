# Common tasks

## Upgrading to a new version
```bash
$ docker-compose exec -u abc nextcloud php /config/www/nextcloud/occ maintenance:mode
$ docker-compose exec -u abc nextcloud php /config/www/nextcloud/occ upgrade
$ docker-compose exec -u abc nextcloud php /config/www/nextcloud/occ maintenance:mode --off
```
Make sure to check whether changes need to be made to
`./config/nginx/site-confs/default` from time to time.

## Rescanning filesystem
Whenever you make changes to the filesystem _outside_ of Nextcloud (like by
mounting a volume in docker to `/data/<username>/files`), you need to index.
This is easy enough:
```bash
$ docker-compose exec -u abc nextcloud php /config/www/nextcloud/occ files:scan <username>
```
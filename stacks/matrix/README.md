# Matrix

## App Services

### Deploying a new Mautrix-based App Service

The general process for adding a mautrix-based AppService is as follows:

1. Pull the appropriate container:

    ```bash
    docker pull dock.mau.dev/tulir/mautrix-facebook:latest
    ```

2. Generate an empty config:

    ```bash
    mkdir mautrix-facebook && cd mautrix-facebook
    docker run --rm -v `pwd`:/data:z dock.mau.dev/tulir/mautrix-facebook:latest
    ```

3. Edit the generated `config.yaml` with the correct values. In particular:

    ```yaml
    homeserver:
      address: http://synapse:8008
      domain: apetre.sc

    appservice:
      address: http://mautrix-facebook:29319
      public:
        enabled: true
        prefix: /public
        external: https://facebook.matrix.apetre.sc/public

    bridge:
      login_shared_secret: <LOGIN_SHARED_SECRET>
      community_template: facebook_{localpart}={server}
      permissions:
        "@apetresc:apetre.sc": "admin"
    ```

4. Generate the registration file:

    ```bash
    $ docker run --rm -v `pwd`:/data:z dock.mau.dev/tulir/mautrix-facebook:latest
    Registration generated and saved to /data/registration.yaml
    Didn't find a registration file.
    Generated one for you.
    Copy that over to synapses app service directory.
    ```

5. Edit `config/homeserver.yaml` to reference the new app service:

    ```yaml
    app_service_config_files:
      - /config/mautrix-facebook/registration.yaml
    ```

6. Add a service to `docker-compose.yaml`:

    ```yaml
      mautrix-facebook:
        image: dock.mau.dev/tulir/mautrix-facebook:latest
        environment:
          - TZ=America/Toronto
        restart: unless-stopped
        volumes:
          - mautrix-facebook:/data
          - ./mautrix-facebook/config.yaml:/data/config.yaml
          - ./mautrix-facebook/registration.yaml:/data/registration.yaml
        depends_on:
          - synapse
        labels:
          traefik.enable: "true"
          traefik.http.routers.mautrix-facebook.rule: "Host(`facebook.matrix.apetre.sc`)"
          traefik.http.services.mautrix-facebook.loadbalancer.server.port: 29319
          traefik.http.routers.mautrix-facebook.tls.certResolver: "r53resolver"
          traefik.http.routers.mautrix-facebook.tls.domains[0].main: "facebook.matrix.apetre.sc"
          traefik.docker.network: proxy
        networks:
          - default
          - proxy

      volumes:
        mautrix-facebook:
    ```

7. Mount the registration file into the homserver:

    ```yaml
      synapse:
        volumes:
          - ./mautrix-facebook/registration.yaml:/config/mautrix-facebook/registration.yaml
    ```

8. Restart synapse (and wait for it to come back up)

    ```bash
    docker-compose restart synapse
    ```

9. Start the bridge:

    ```bash
    docker-compose up -d mautrix-facebook
    ```

10. _(Optional)_ Add a subdomain for the public pages:

    ```bash
    add-apetresc-subdomain facebook.matrix
    ```

## Re-registering a Mautrix-based App Service

1. Stop the AppService

2. Re-generate in-place

    ```bash
    docker-compose run --rm mautrix-facebook python3 -m mautrix_facebook -g -c /data/config.yaml -r /data/registration.yaml
    ```

3. Restart synapse

4. Bring the AppService back up

## Notes

- You need to manually chown the volume for some reason:

  ```bash
  docker-compose create
  sudo chown -R apetresc:apetresc /var/lib/docker/volumes/matrix_data
  docker-compose up
  ```

- The initial user needs to be created via a script:

  ```bash
  docker-compose exec synapse register_new_matrix_user \
    -u apetresc -p "LQGyQwkE6Ni5PvhFpugr2xiM" \
    -a -c /config/homeserver.yaml \
    http://synapse:8008
  ```

## Links

- Delegation is described [here](https://github.com/matrix-org/synapse/blob/master/docs/delegate.md)
- If this one doesn't work out, consider [matrix-docker-ansible-deploy](https://github.com/spantaleev/matrix-docker-ansible-deploy)
  which seems to support a ton of other services that I don't quite understand
  the need for yet.

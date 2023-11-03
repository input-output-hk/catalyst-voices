# Catalyst Event Database

This crate defines the structure and RUST access methods for the Catalyst Event Database.

## Starting a Local Test DB with Docker and Earthly

Firstly you will need to prepare a docker images with all migrations and data.

Prepare a event-db docker image with the historic data
(from the root directory)

```sh
earthly ./catalyst-gateway/event-db+docker
```

Prepare a event-db docker image with the test data
(from the root directory)

```sh
earthly ./catalyst-gateway/event-db+docker --data=test
```

Run a event db docker container
(from the root directory)

```sh
docker-compose -f catalyst-gateway/event-db/docker-compose.yml up migrations
```

This will run postgres on port `5432`.

To test that docker image builds fine and migrations correctly applies run

```sh
earthly ./catalyst-gateway/event-db+integrate
```


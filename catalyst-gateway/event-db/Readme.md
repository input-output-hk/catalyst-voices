# Catalyst Event Database

This crate defines the necessary migrations, seed data and docker image builder for the Catalyst Event Database.

## Starting a Local Test DB with Docker and Earthly

Firstly you will need to prepare a docker images with all migrations and data.

Prepare a event-db docker image with the historic and test data

```sh
earthly ./catalyst-gateway/event-db+build --tag "latest" --registry "" --with_historic_data true --with_test_data true
```

Run a event db docker container

```sh
docker-compose -f catalyst-gateway/event-db/docker-compose.yml up event-db
```

This will run postgres on port `5432`.

To test that docker image builds fine and migrations correctly applies run

```sh
earthly -P ./catalyst-gateway/event-db+test
```

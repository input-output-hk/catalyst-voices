# Catalyst Event Database

This dir defines the structure and some historic data for the Catalyst Event Database.

## Starting a Local Test DB with Docker and Earthly

Firstly you will need to prepare a docker images with all migrations and data.

Prepare a event-db docker image with the historic data
(from the root directory)

```sh
earthly ./containers/event-db-migrations+docker
```

Prepare a event-db docker image with the test data
(from the root directory)

```sh
earthly ./containers/event-db-migrations+docker --data=test
```

Run a event db docker container
(from the root directory)

```sh
docker-compose -f src/event-db/docker-compose.yml up migrations
```

This will run postgres on port `5432`

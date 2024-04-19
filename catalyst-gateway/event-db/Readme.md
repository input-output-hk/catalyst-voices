# Catalyst Event Database

This crate defines the necessary migrations, seed data and docker image builder for the Catalyst Event Database.

## Starting a Local Test DB with Docker and Earthly

Firstly you will need to prepare a docker images with all migrations and data.

Prepare and build an event-db docker image

```sh
earthly +build
```

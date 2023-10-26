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

## GraphQL

GraphQL is ONLY used for the admin interface.
It is configured with the `setup/graphql-setup.sql`.

For local testing, make sure the local `event-db` is setup and running, as described above.
Then:

```sh
setup/start-graphql.sh
```

See <https://www.graphile.org/postgraphile/> for documentation on the GraphQL server.

### GraphQL Users

There are two GraphQL Users:

* `cat_admin`: Full admin access to the database.
* `cat_anon`: Unauthenticated read-only access to the database.

To authenticate, as the `cat_admin` user, execute the `authenticate` mutation.
This will return a Signed JWT Token for the user.
The JWT Token needs to be included as a `bearer` token `Authorization` header in subsequent requests.
Authentication only last 1 Hour, after which a new token must be requested.

When authenticated as the `cat_admin` user, new `cat_admin` users can be registered with the `registerAdmin` mutation.

Further Security Roles or Admin management functions can be added as required.

#### Authentication API

The GraphQL server exposes 2 **Mutations** that are used for security.

If the user is NOT authenticated, they can not update any data in the database, only read data.

To authenticate run the `authenticate` mutation with the email address and password of the user to be authenticated.
If successful, this mutation will return a JWT which will have 1 hr of Life.
Place the returned JWT in an `Authorization: Bearer <JWT>` header for all subsequent calls.

`currentAcct` query will return the authenticated user's current account details and role.

To register a new user, the `registerAdmin` mutation can be used.
It will only work if the user is properly authenticated with a `cat_admin` role.

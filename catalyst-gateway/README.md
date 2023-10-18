# Catalyst Data Gateway

The Catalyst Data Gateway is the backend of the Catalyst Voices hosted stack.

It provides the backend data infrastructure to the catalyst central databases.
In future it will also act as a gateway from Centralized catalyst infrastructure to decentralized infrastructure.

## Code Organization

### `./bin`

This is the main Catalyst Gateway Application.

### `./crates`

These are fully re-usable generalized `rust` crates that the Catalyst Gateway uses and are developed with it.
They are also able to be used stand-alone in other projects and can be published separately.

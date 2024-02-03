# Integration testing for DB Schema Version Mismatch behavior

Sets up a containerized environment with the `EventDB` and `catalyst-gateway` services running.

Integration tests are run in this environment that probe the behavior of the `catalyst-gateway` service in situations
where the DB schema version changes during execution, and creates a mismatch with the version that gateway service expects.

## Running

To run:

```bash
earthly -P +test
```

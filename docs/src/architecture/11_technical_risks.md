---
icon: fontawesome/solid/biohazard
---

# Risks and Technical Debts

<!-- See: https://docs.arc42.org/section-11/ -->

Known risks:

* Chain data freshness and rollback handling can delay RBAC or stake updates.
* Web platform variance for WASM and required headers can break local persistence.
* Client key management errors can lock users out or expose sensitive material.
* Drift and SQLite version mismatches can affect JSONB queries on some devices.
* Scylla cluster operations and schema tuning require specialist expertise.
* Under load, idempotent document PUTs must avoid duplicate writes and race conditions.
* Clock skew between client and server can cause event timing edge cases.
* Privacy configurations must balance transparency with data minimization.

Mitigations and follow-ups:

* Expose freshness metrics and backpressure when caches fall behind thresholds.
* Provide platform specific setup and CI tests for Web, Android, and iOS.
* Offer clear key recovery guidance and test vectors for derivation.
* Run schema migrations and compatibility tests across supported platforms.
* Automate cluster checks and alerting for Scylla and Postgres health.
* Use optimistic concurrency and stable identifiers to deduplicate writes.
* Validate event windows server side and include timing in responses.

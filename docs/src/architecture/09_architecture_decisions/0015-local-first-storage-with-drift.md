---
    title: 0015 Local First Storage with Drift and sqlite3.wasm
    adr:
        author: Assistant
        created: 29-Oct-2025
        status: accepted
    tags:
        - flutter
        - drift
        - sqlite
        - offline
---

## Context

Catalyst Voices must remain responsive and resilient across Web and Mobile with intermittent connectivity.
Local persistence enables offline workflows and quick UI updates without blocking on network round trips.

## Assumptions

* Web requires `sqlite3.wasm`, COOP, and COEP headers for Drift to function.
* Mobile can use native SQLite via `sqlite3_flutter_libs`.

## Decision

Use Drift for local persistence across platforms, with `sqlite3.wasm` on Web and native SQLite on Mobile.
Structure repositories to reconcile local state with server responses and background refresh.

## Rationale

Drift provides a uniform data access layer with reactive updates and strong tooling.
The approach improves perceived performance and supports offline continuity.

## Implementation Guidelines

* Generate Drift code and migrations as part of the CI flow.
* Ensure Web builds serve `sqlite3.wasm` with `application/wasm` and include COOP and COEP headers.
* Design tables and indices for common queries and pagination.

## Risks

Platform specific quirks can cause divergence, especially on Web.
Schema migrations must be tested across platforms.

## Consequences

Responsive UI and resiliency to transient failures.
Additional maintenance for migrations and platform setup.

## More Information

* [Drift](https://drift.simonbinder.eu/)
* [sqlite3.wasm](https://github.com/simolus3/sqlite3.dart)

---
    title: 0012 Scylla for Chain Indexing Caches
    adr:
        author: Assistant
        created: 29-Oct-2025
        status: accepted
    tags:
        - scylla
        - cassandra
        - indexing
        - data
---

## Context

Gateway requires a horizontally scalable store for chain follower state and read heavy caches.
The workload is append heavy with time ordered access patterns and large working sets.
Operational simplicity and predictable performance under load are priorities.

## Assumptions

* Keyspaces and column families must be tuned for access patterns typical of chain data.
* We need multi node resilience and linear scaling characteristics.

## Decision

Use Scylla, a Cassandra compatible database, for persistent and volatile chain indexing caches.
Design schemas to support time based partitioning and efficient pagination.

## Rationale

Scylla offers predictable latencies and high throughput with operational compatibility to Cassandra.
It fits the read and write patterns of the chain follower and downstream API consumers.

## Implementation Guidelines

* Separate keyspaces for persistent and volatile data with tailored TTLs.
* Expose freshness metrics and cache hit ratio for observability.
* Keep API stateless and derive responses from caches where possible.

## Risks

Cluster operations and schema tuning require expertise.
Misconfigured partitions can lead to hotspots and uneven load distribution.

## Consequences

Low latency chain derived endpoints at scale.
Operational overhead for cluster management offset by performance gains.

## More Information

* [ScyllaDB Documentation](https://docs.scylladb.com/)

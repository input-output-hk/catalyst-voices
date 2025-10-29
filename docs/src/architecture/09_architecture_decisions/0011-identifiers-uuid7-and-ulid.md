---
    title: 0011 Identifier Strategy (UUIDv7 and ULID)
    adr:
        author: Assistant
        created: 29-Oct-2025
        status: accepted
        extends:
            - 0009-uuid7-vs-ulid
    tags:
        - uuid
        - ulid
        - identifiers
---

## Context

The system needs globally unique identifiers that preserve ordering where helpful and remain efficient across storage engines.
Gateway code and APIs already use UUIDv7 for document and version identifiers, while some header and type identifiers use ULID.
We need a clear, consistent identifier strategy that reflects the current implementation.

## Assumptions

* Time ordering improves pagination and locality in logs and storage for certain entities.
* Standard UUID support in databases and languages reduces friction in integration.
* Some ancillary identifiers benefit from short, lexicographically sortable values.

## Decision

Use UUIDv7 for all primary document and version identifiers that benefit from time ordering.
Use ULID for select header fields and type identifiers where a compact, sortable string is desirable.
Avoid mixing identifier types for the same field and document clearly in API contracts.

## Rationale

UUIDv7 is standardized and integrates well with databases and tooling.
ULID provides compact, sortable identifiers where native UUID types are not required.
This dual approach matches the current gateway implementations and preserves operational benefits.

## Implementation Guidelines

* Prefer database native UUID types for UUIDv7 fields.
* Treat ULIDs as strings at storage and validation boundaries.
* Document the identifier type in OpenAPI schemas and examples.
* Do not reuse the same field for different identifier types.

## Risks

Two identifier types can confuse developers if not documented and enforced.
Client libraries must validate and format both correctly.

## Consequences

Better alignment with existing code and storage models.
Predictable sorting and pagination for time ordered resources.
Minimal migration effort compared to a single type strategy.

## More Information

* [RFC 9562 - UUIDv7 Specification](https://datatracker.ietf.org/doc/rfc9562/)
* [ULID Specification](https://github.com/ulid/spec)

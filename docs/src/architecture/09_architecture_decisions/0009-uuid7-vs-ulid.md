---
    title: 0009 UUIDv7 vs ULID
    adr:
        author: Assistant
        created: 17-Oct-2024
        status: proposed
    tags:
        - uuid
        - identifiers
---

## Context

The system needs globally unique identifiers for various entities and resources.
Currently, we use ULIDs (Universally Unique Lexicographically Sortable Identifiers) in some parts of the system.
With the recent standardization of UUIDv7 through [RFC 9562], we need to evaluate our identifier strategy.

## Assumptions

* We need time-ordered, globally unique identifiers for certain system components
* We need non-time-ordered unique identifiers for type identification
* Our systems must interact with various external systems and databases

## Decision

We will:

* Use UUIDv7 for all time-bound unique identifiers (replacing ULID usage)
* Use UUIDv4 for type-specific identifiers where time ordering is not required
* Phase out ULID usage in favor of UUIDv7

### Rationale

* UUIDv7 provides similar benefits to ULID:
  * Time-ordered
  * Globally unique
  * Contains timestamp information
* UUIDv7 has several advantages over ULID:
  * Standardized through RFC 9562
  * Wider system compatibility (native UUID support)
  * No special encoding requirements
  * Clear disambiguation from UUIDv4 (allowing two distinct identifier spaces)
  * Eliminates need for custom ULID code
  * Better database indexing support
* Standard UUID implementations are widely available across programming languages and platforms

### Implementation Guidelines

* New features should exclusively use:
  * UUIDv7 for time-ordered identifiers
  * UUIDv4 for non-time-ordered type identifiers
* Existing ULID implementations should be migrated to UUIDv7 during regular maintenance cycles
* Database schemas should use UUID types rather than string/custom types
* API contracts should specify UUID format requirements in their documentation

## Risks

* Migration from existing ULID implementations requires careful planning
* Some existing data may need conversion
* Team members need to understand when to use UUIDv4 vs UUIDv7

## Consequences

### Positive

* Improved system interoperability
* Reduced custom code maintenance
* Better alignment with industry standards
* Simplified database operations
* Two distinct identifier spaces (v4 and v7) for different use cases

### Negative

* Migration effort required for existing ULID implementations
* Team training needed for proper UUID version selection

## More Information

* [RFC 9562 - UUIDv7 Specification](https://datatracker.ietf.org/doc/rfc9562/)
* [ULID Specification](https://github.com/ulid/spec)

[RFC 9562]: https://datatracker.ietf.org/doc/rfc9562/ 
---
    title: 0017 CIP-509 as Primary Registration, CIP-36 Legacy Only
    adr:
        author: Assistant
        created: 29-Oct-2025
        status: accepted
    tags:
        - cardano
        - cip-509
        - cip-36
        - rbac
---

## Context

Catalyst is transitioning from legacy voter registrations tracked under CIP-36 to a new approach under CIP-509.
Gateway and clients must align on registration data sources for permissions and voting power.

## Assumptions

* New events will rely on CIP-509 registration flows.
* Historical compatibility is required for prior events and data.

## Decision

Use CIP-509 as the primary specification for new voter registrations and RBAC registration chains.
Maintain legacy support for CIP-36 endpoints and data for historical compatibility only.

## Rationale

CIP-509 aligns registrations and RBAC with Catalyst governance and simplifies server side authorization checks.
Legacy CIP-36 remains available to avoid breaking older data or tools.

## Implementation Guidelines

* Clearly mark CIP-36 endpoints as legacy in API docs and client code.
* Prefer CIP-509 data paths in new features and documentation.
* Ensure snapshots and caches reflect the distinction in metrics and headers.

## Risks

Dual support can confuse developers and users if not documented.
Migrations may require data reconciliation for legacy records.

## Consequences

Consistent path forward for new registrations while preserving backwards compatibility.
Clear deprecation messaging enables gradual adoption.

## More Information

* CIP-509 (internal documentation)
* [CIP-36](https://cips.cardano.org/cip/CIP-36)

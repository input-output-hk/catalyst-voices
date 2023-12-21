---
    title: 0001 Architecture Documentation Standard
    adr:
        author: Steven Johnson
        created: 15-Nov-2023
        status:  accepted
    tags:
        - arc42
---

## Context

There needs to be a commonly understood and well documented structure to Architecture Documentation.
Architecture Documentation is the responsibility of the entire team.
A standardized structure to that documentation helps with collaboration.

## Assumptions

* Architecture documentation is the collective responsibility of the development team.
* A well documented structure to that documentation will aid in collaboration and maintenance of the documentation.

## Decision

We will be using the [arc42] standard for organizing architecture documentation.

## Risks

* That [arc42] becomes unmaintained upstream, or some flaw is found with its methodology.
* That the team does not understand the structure of the architecture documentation or necessity to maintain it.

## Consequences

If we do:

* It is easier to maintain documentation when there is an agreed structure to it.
* It is easier to on-board new members of the team when there are resources to help understand the documentation and its structure.
* Architecture Documentation will be of higher quality and more meaningfully reviewed in the context of an agreed structure.

If we don't:

* Architecture docs will be "ad-hoc".
* Difficult for the team to meaningfully collaborate on Architecture.
* Difficult to maintain.
* Difficult to ensure the necessary information is captured.
* Difficult to iterate and be agile.

## More Information

* [arc42]
* [Original Templates](https://github.com/arc42/arc42-template/tree/master/dist)
* [Main Documentation](https://docs.arc42.org/home/)
* [Books](https://leanpub.com/b/arc42complete)
* [Examples](https://arc42.org/examples)

[arc42]: https://arc42.org

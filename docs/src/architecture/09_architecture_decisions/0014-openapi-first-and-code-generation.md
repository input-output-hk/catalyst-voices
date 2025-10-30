---
    title: 0014 OpenAPI First and Code Generation
    adr:
        author: Assistant
        created: 29-Oct-2025
        status: accepted
    tags:
        - openapi
        - poem
        - codegen
        - swagger-dart
---

## Context

We maintain a Rust backend and Flutter clients that must evolve together without drift.
Manual client implementations are error prone and slow down iteration.

## Assumptions

* Backend can produce OpenAPI artifacts during builds.
* Flutter code can be generated reliably from OpenAPI specs.

## Decision

Adopt an OpenAPI first workflow using `poem_openapi` on the backend and `swagger_dart_code_generator` on the client.
Package artifacts via Earthly and integrate generated client code into the repositories layer.

## Rationale

Typed contracts and generated clients reduce integration bugs and speed up feature delivery.
OpenAPI artifacts also enable documentation and automated testing.

## Implementation Guidelines

* Define routes and schemas with `poem_openapi` annotations.
* Publish OpenAPI artifacts from backend Earthly targets.
* Generate Dart clients into the internal repositories package and review diffs.

## Risks

Generator limitations or breaking changes can block upgrades.
Specs must remain accurate to avoid client breakages.

## Consequences

Faster consistent client integrations.
Single source of truth for API contracts and documentation.

## More Information

* [poem-openapi](https://github.com/poem-web/poem)
* [swagger_dart_code_generator](https://pub.dev/packages/swagger_dart_code_generator)

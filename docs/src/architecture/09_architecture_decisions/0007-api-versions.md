---
    title: 0007 Api Versions
    adr:
        author: Steven Johnson
        created: 16-Oct-2024
        status:  proposed
    tags:
        - api
---

## Context

The Catalyst Voices backend service, known as Catalyst Gateway, provides an HTTP API to front end services.

It is required that the API be:

* Stable enough for Frontend integrations to be reliable;
* Flexible enough to allow endpoints to evolve, be modified or removed over time.

A secondary consideration is that wherever practical, the API be defined such that it can be replicated on the Hermes Engine.

## Assumptions

That Catalyst Gateway will provide its API's with an HTTP API, defined by an OpenAPI specification.

## Decision

All Individual API Endpoints will be named and versioned according to the following rules:

1. All endpoints URIs will be under the `/api` path in the backend.
2. The general structure of any endpoint will be `/api/<version>/<path>`
3. `<version>` defines a version of the endpoint supplied by a `<path>` and is **NOT** aligned with any other versions.
4. `<version>` **MUST** either be `draft` or matching the regular expression `^v(?!0)\d{1,}$`[^1]
5. `<path>` Can be any path of at least one element as required for the endpoint.
6. **ALL** new endpoints start as `draft` they are promoted to a versioned endpoint by a deliberate decision.
7. New endpoints **MUST NOT** be versioned other than `draft` in their initial PR.
8. New endpoints can only be versioned after the behavior and form of the endpoint has been validated, in a subsequent PR.
9. *ALL* draft endpoints are subject to change and can be safely modified in any way.
10. `draft` Versioned endpoints can be used by frontend code.  
However, if the API changes or disappears, the front end should fail gracefully.
11. The numbered version of an endpoint will always start at `v1` and increments sequentially.
12. API versions are **ONLY** incremented if their behavior changes in a way that can reasonably be considered a breaking change
with respect to the currently published OpenAPI specification for that Endpoint.
13. The API endpoint versions are not aligned to any semantic versioning of the backend.
14. `draft` endpoints should not be tested in CI, in such a way as they break the CI pipeline if they change.
15. **ALL** versioned endpoints **SHOULD** have CI tests which ensure the API endpoint itself has not changed in a breaking way.
16. Code generation can generate code for `draft` endpoints, provided doing so does not result in breaking CI.
17. Any Integration tests written against `draft` endpoints should not fail.  
They may produce warnings if they do not match expected outputs.
18. Re-versioning an endpoint is NOT required if the change to it is backward compatible with the existing endpoint.
A non-exhaustive list of possible cases for this are:
    * A new *OPTIONAL* query parameter is added to an endpoint.
    * A response field is added, and the OpenAPI document defined that `"additionalProperties": true`
in the schema definition where the additional field is to be added.
    * A previously undocumented behavior is documented.  
In this case, the behavior must already exist, it is not a breaking change to clarify documentation.
19. *ALL* non-breaking changes proposed in a PR to existing API's,
or migrating an API from `draft` to a versioned API **MUST** be signed off by
    * at least 1 Architect on the Team; and
    * the Engineering manager; and preferably
    * A senior member of the team with primary responsibility for the frontend.
20. When a new version of an endpoint is released, the existing endpoint **MUST** be marked as `deprecated`
in the OpenAPI specification for the endpoint.
This **MUST** occur in the same PR as the PR that moves the endpoint from `draft` to a versioned API.
21. PRs which version a `draft` endpoint **SHOULD ONLY** include the following.
There can be no other changes to the logic in an API versioning PR.
    * The change from `draft` to the required version;
    * If it supersedes an existing endpoint version, marking that endpoint as `deprecated`.
    See: [Deprecating Endpoints in OpenAPI]
    * Updating any draft integration tests to match the new version of the endpoint, and ensure they will Fail CI if they fail.
22. There is no requirement that `draft` endpoints must enter production.
    * Endpoints can go from `draft` to a versioned endpoint during the development of a single release.
    * Conversely, there is no problem with `draft` endpoints entering production if they are not stable at the time of a release.
23. `draft` endpoints have the same security requirements as versioned endpoints.
    * The only difference is the query parameters, path or responses are not stable and can change.

The purpose of these rules is to allow us to iterate quickly and implement new API endpoints.
And remove unnecessary risks of breaking the front end, or CI, while adding new endpoints.

Currently, the API is mostly unstable.  
We also do not have any external consumers of the API to consider.
However, once we enter production with the API we will need a strategy for deprecating and removing obsolete API endpoints.
That will be the subject of a further ADR related specifically to that topic.

### Example - adding a new endpoint

New endpoints always start as drafts.

Initial PR commits the following endpoint, to get a voters voting power:

```url
https://dev.catvoices.io/api/draft/voter/power
```

After the endpoint is considered stable,
A subsequent PR will make a single change to update the version, starting at `v1`.

```url
https://dev.catvoices.io/api/v1/voter/power
```

### Example - updating an existing new endpoint

An existing endpoint at V2:

```url
https://dev.catvoices.io/api/v2/voter/registration
```

#### PR to add make breaking change to that endpoint

A PR is raised with a breaking change to that endpoint.
It adds a required query parameter.
This endpoint once stable will become v3.

```url
https://dev.catvoices.io/api/draft/voter/registration?requiredParam=true
```

#### PR Merged, and new draft endpoint exposed

Once merged, the service will expose these two endpoints.

```url
https://dev.catvoices.io/api/v2/voter/registration
https://dev.catvoices.io/api/draft/voter/registration?requiredParam=true
```

#### PR to set version

When the new draft endpoint is stable, a new PR is raised to change it from `draft` to `v3`.
The `v2` endpoint will be marked [deprecated][Deprecating Endpoints in OpenAPI].

```url
https://dev.catvoices.io/api/v2/voter/registration <- deprecate
https://dev.catvoices.io/api/v3/voter/registration?requiredParam=true
```

#### v2 and v3 endpoints exposed

After merge the service will expose these two endpoints.

```url
DEPRECATED: https://dev.catvoices.io/api/v2/voter/registration
https://dev.catvoices.io/api/v3/voter/registration?requiredParam=true
```

## Risks

There are no significant risks identified for the ADR.

## Consequences

If we do not do this, change management of the API will quickly become difficult and unreliable.

## More Information

* [Free Code Camp - How to Version a REST API](https://www.freecodecamp.org/news/how-to-version-a-rest-api/)
* [Postman - API Versioning](https://www.postman.com/api-platform/api-versioning/)
* [Deprecating Endpoints in OpenAPI]

[Deprecating Endpoints in OpenAPI]: <https://openapispec.com/docs/how/how-does-openapi-handle-api-deprecation/)>

[^1]: `^` asserts the position at the start of the string.</br>
`v` matches the character `v`.</br>
`(?!0)` is a negative look-ahead assertion that checks if the digit after 'v' is not equal to 0.</br>
`\d{1,}` matches one or more digits (1 to unlimited) which ensures that there are no leading zeros in the numeric part of the string.</br>
`$` asserts the position at the end of the string.</br>
For example, `v123` would be a valid string, but `v0` or `v00789` would not match this pattern because they have leading zeros in the numeric part of the string.

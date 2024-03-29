# Catalyst Voices Services

## Automated Code Generation

This package is used for the code generation from the OpenAPI specifications.
It leverages `swagger_dart_code_generator` library and the artifacts generated
for the documentation of the `catalyst-gateway` backend.
The process consists in 3 simple steps:

1. The OpenAPI specification is picked from the artifact generated in the
`Earthfile` of `catalyst-gateway`.
2. The code is generated and saved as an artifact in the `Earthfile` of
`catalyst_voices`
3. Generated code is placed in the proper location within the `catalyst_voices`
project (`packages/catalyst_voices_models/lib/generated`) and it's ready for
local usage.

This process can be achieved by executing from the `catalyst_voices` root
folder:

```sh
earthly +code-generator-local
```

In this way it's possible to generate locally the code using the same version of
OpenAPI specs defined in the backend code and developers have full control of
what must be committed.

To ensure the consistency of the generated code (especially when backend changes
occur) an earthly target is automatically executed on PR against main.
This `+test-flutter-code-generator` generates the code on the CI and compares it
with the code currently in repo, failing if there is an inconsistency.

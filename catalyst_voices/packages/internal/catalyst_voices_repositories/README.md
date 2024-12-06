# Catalyst Voices Repositories

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
   project (`packages/internal/catalyst_voices_repository/lib/generated/api`)
   and it's ready for local usage.

This process can be achieved by executing from the `catalyst_voices` root
folder:

```sh
earthly +code-generator --platform=linux/amd64 --save_locally=true
```

The `--platform=linux/amd64` flag is necessary only when running the command from
a different platform such as **Windows** or **macOS**.
It ensures that the code generation process is compatible with the target platform.
If you are running the command on a **Linux** platform, you can omit this flag.

In this way it's possible to locally generate the code using the same version of
OpenAPI specs defined in the backend code and developers have full control of
what should be committed.
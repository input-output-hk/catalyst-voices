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

## Database

### Drift

Files have to be generated with build runner command.

```bash
dart run build_runner clean && \
dart run process_openapi.dart && \
dart run build_runner build --delete-conflicting-outputs
```

or melos

```bash
melos build_runner_repository
```

Build migration test files with

```bash
melos db-make-migration
```

#### Web

Use same port while building for db to be restored. `--web-port=5555`

Additional headers

* `Cross-Origin-Opener-Policy`: Needs to be set to `same-origin`.
* `Cross-Origin-Embedder-Policy`: Needs to be set to `require-corp`.

Read more [here](https://drift.simonbinder.eu/platforms/web/#additional-headers).

Drift requires **driftWorker** and **driftWorker**

Those files can be compiles by hand or downloaded from

* [sqlite3Wasm](https://github.com/simolus3/sqlite3.dart/releases)
* [driftWorker](https://github.com/simolus3/drift/releases).

`sqlite3.wasm` file needs to be served with a `Content-Type` of `application/wasm` since browsers
will reject the module otherwise.

Read more [here](https://drift.simonbinder.eu/platforms/web/#prerequisites).

#### Native

TODO

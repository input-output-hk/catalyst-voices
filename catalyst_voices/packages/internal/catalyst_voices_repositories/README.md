# Catalyst Voices Repositories

## Database

**CatalystDatabase** depends on jsonb queries, which was introduced in sqlite 3.45.0.
Read more [here](https://sqlite.org/jsonb.html).
This means we need to ensure minimum version.

### Drift

Files have to be generated with build runner command.

```bash
dart run build_runner build --delete-conflicting-outputs
```

or melos

```bash
melos build-runner
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

We're using [Native Drift](https://drift.simonbinder.eu/Platforms/vm/) for android and iOS.

Ensuring minimum version of sqlite by shipping with
[sqlite3_flutter_libs](https://pub.dev/packages/sqlite3_flutter_libs)
which is linking compiled version of sqlite3.dart.

* for android in build.gradle (**/android/build.gradle**).
* for darwin (iOS) in sqlite3_flutter_libs.podspec (**/darwin/sqlite3_flutter_libs.podspec**).

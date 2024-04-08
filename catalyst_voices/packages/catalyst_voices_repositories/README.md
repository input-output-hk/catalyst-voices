# Catalyst Voices Repositories

## Catalyst Data Gateway Repository

### Tests

When extending the `CatalystDataGatewayRepository` it is necessary to generate
proper mocks to have them available in tests.
To do that we need to run

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

 or

 ```sh
dart run build_runner build --delete-conflicting-outputs
```

in the Catalyst Voices Repositories package root.
The decorator `@GenerateNiceMocks` provided by mockito is used to indicate the
repository to generate the mocks for.

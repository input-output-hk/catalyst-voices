# Catalyst Voices Repositories

## Catalyst Data Gateway Repository

The `CatalystDataGatewayRepository` provides a structured interface to
interact with the `catalyst-gateway` backend API.
Network communication and error handling is abstracted allowing the
integration of API calls in an easy way.
All methods return `Future` objects to allow async execution.

### Usage examples

Repository needs to be initialized by passing the API base URL:

```dart
final repository = CatalystDataGatewayRepository(Uri.parse('https://example.org/api'));
```

Check the health status of the service:

```dart
final health_status = await repository.getHealthLive();
```

Fetch staked ADA by stake address:

```dart
final stake_info = await repository.getCardanoStakedAdaStakeAddress(
  // cspell: disable-next-line
  stakeAddress: 'stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw',
);
```

Get sync state:

```dart
final sync_state = await mock.getCardanoSyncState();
```

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

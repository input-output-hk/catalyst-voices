# Flutter Integration Tests

* [Flutter Integration Tests](#flutter-integration-tests)
  * [Introduction](#introduction)
  * [Run Integration Tests](#run-integration-tests)
    * [Web](#web)
    * [iOS](#ios)
    * [Android](#android)
  * [Links](#links)

## Introduction


## Run Integration Tests

### Web

```sh
flutter drive --driver=test_driver/integration_test.dart \
--target=integration_test/main.dart \
--flavor development \
-d web-server
```

### iOS


```sh
flutter drive --driver=test_driver/integration_test.dart \
--target=integration_test/main.dart \
--flavor development \
-d web-server
```

### Android

```sh
flutter drive --driver=test_driver/integration_test.dart \
--target=integration_test/main.dart \
--flavor development \
-d web-server
```

## Links

- [Flutter Integration Tests](https://flutter.dev/docs/testing/integration-tests)
- [Flutter Integration Tests GitHub](https://github.com/flutter/flutter/tree/main/packages/integration_test)
- [Running Flutter Driver tests with Web](https://github.com/flutter/flutter/wiki/Running-Flutter-Driver-tests-with-Web)
- [Web install scripts for CI for Flutter Web](https://github.com/flutter/web_installers/tree/master)
- [Integration Test Example](https://github.com/flutter/flutter/tree/main/packages/integration_test/example)
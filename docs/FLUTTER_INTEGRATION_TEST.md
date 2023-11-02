# Flutter Integration Tests

* [Flutter Integration Tests](#flutter-integration-tests)
  * [Introduction](#introduction)
  * [Run Integration Tests](#run-integration-tests)
    * [CI](#ci)
    * [Web](#web)
    * [iOS](#ios)
      * [Run integration test in Xcode](#run-integration-test-in-xcode)
    * [Android](#android)
      * [Run integration test in Firebase Test Lab](#run-integration-test-in-firebase-test-lab)
  * [Links](#links)

## Introduction

## Run Integration Tests

### CI

```sh
./flutter_web_integration_test.sh
```

### Web

```sh
flutter drive --driver=test_driver/integration_test.dart \
--target=integration_test/main.dart \
--flavor development \
-d web-server
```

### iOS

#### Run integration test in Xcode

Build the integration test for iOS

```sh
flutter build ios --config-only integration_test/main.dart --flavor development
```

Open iOS app in Xcode, select appropriate schema and run the integration test target `Product > Test` or `Cmd + U`.

```sh
flutter test integration_test/main.dart --flavor development
```

### Android

```sh
flutter test integration_test/main.dart --flavor development
```

#### Run integration test in Firebase Test Lab

```sh
flutter drive --driver=test_driver/integration_test.dart \
--target=integration_test/main.dart \
--flavor development
```

## Links

* [Flutter Integration Tests](https://flutter.dev/docs/testing/integration-tests)
* [Flutter Integration Tests GitHub](https://github.com/flutter/flutter/tree/main/packages/integration_test)
* [Running Flutter Driver tests with Web](https://github.com/flutter/flutter/wiki/Running-Flutter-Driver-tests-with-Web)
* [Web install scripts for CI for Flutter Web](https://github.com/flutter/web_installers/tree/master)
* [Integration Test Example](https://github.com/flutter/flutter/tree/main/packages/integration_test/example)

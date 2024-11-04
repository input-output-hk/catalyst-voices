# Flutter Integration Tests

* [Flutter Integration Tests](#flutter-integration-tests)
  * [Requirements](#requirements)
  * [Run Integration Tests](#run-integration-tests)
    * [CI](#ci)
      * [View Integration Test Results](#view-integration-test-results)
    * [Local](#local)
      * [Web](#web)
      * [iOS](#ios)
        * [Run integration test in Xcode](#run-integration-test-in-xcode)
        * [Run integration test from command line](#run-integration-test-from-command-line)
      * [Android](#android)
        * [Run integration test in Android Studio](#run-integration-test-in-android-studio)
        * [Run integration test from command line](#run-integration-test-from-command-line-1)
    * [Run integration test in Firebase Test Lab](#run-integration-test-in-firebase-test-lab)
  * [Gcloud CLI](#gcloud-cli)
  * [Links](#links)

## Requirements

* macOS 14.0 + (if you want to run iOS tests locally)
* Xcode: 14.2+ (required for iOS tests)
* Android Studio: Android Studio Electric Eel | 2022.1.1 +
* [gcloud CLI](https://cloud.google.com/sdk/gcloud)

## Run Integration Tests

### CI

* We run integration test for Web on every PR using chromedriver.
* We use [FireBase Test Lab](https://firebase.google.com/docs/test-lab) to run integration tests on iOS and Android,
nightly.(It's expensive to run integration tests on iOS and Android on every PR)

#### View Integration Test Results

To view integration tests results for Web, iOS and Android,
navigate to [Firebase Test Lab](https://console.firebase.google.com/u/0/project/dev-catalyst-voice/testlab/histories)
and select the appropriate history.

### Local

#### Web

>On Ubuntu you might be required to start chromedriver.
>In a separate terminal run: `chromedriver --port=4444`

Navigate to `catalyst_voices/apps/voices` and run:

```sh
flutter drive --driver=test_driver/integration_tests.dart \
--target=integration_test/main.dart \
--flavor development \
-d chrome
```

#### iOS

##### Run integration test in Xcode

Navigate to `catalyst_voices/apps/voices`

Build the integration test for iOS

```sh
flutter build ios --config-only integration_test/main.dart --flavor development
```

Open iOS app in Xcode, select appropriate schema and run the integration test target `Product > Test` or `Cmd + U`.

##### Run integration test from command line

Navigate to `catalyst_voices/apps/voices`

Start iOS Simulator or connect iOS device and run:

```sh
flutter test integration_test/main.dart --flavor development
```

#### Android

##### Run integration test in Android Studio

Navigate to `catalyst_voices/apps/voices/android` start Android Emulator or connect Android device and run:

```sh
./gradlew app:connectedAndroidTest -Ptarget=`pwd`/../integration_test/main.dart
```

>Note: To use --dart-define with gradlew you must base64 encode all parameters,
>and pass them to gradle in a comma separated list:

```sh
./gradlew project:task -Pdart-defines="{base64(key=value)},[...]"
```

##### Run integration test from command line

Navigate to `catalyst_voices/apps/voices` start Android Emulator or connect Android device and run:

```sh
flutter test integration_test/main.dart --flavor development
```

### Run integration test in Firebase Test Lab

Android:

```sh
./catalyst_voices/scripts/flutter_android_integration_test.sh
```

iOS:

```sh
./catalyst_voices/scripts/flutter_ios_integration_test.sh
```

## Gcloud CLI

List available android devices:

```sh
gcloud firebase test android models list
```

List available iOS devices:

```sh
gcloud firebase test ios models list
```

## Links

* [Flutter Integration Tests](https://flutter.dev/docs/testing/integration-tests)
* [Flutter Integration Tests GitHub](https://github.com/flutter/flutter/tree/main/packages/integration_test)
* [Running Flutter Driver tests with Web](https://github.com/flutter/flutter/wiki/Running-Flutter-Driver-tests-with-Web)
* [Web install scripts for CI for Flutter Web](https://github.com/flutter/web_installers/tree/master)
* [Integration Test Example](https://github.com/flutter/flutter/tree/main/packages/integration_test/example)

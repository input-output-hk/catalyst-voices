#!/bin/bash
set -e

output="../build/ios_integ"
product="build/ios_integ/Build/Products"

pushd catalyst_voices
flutter build ios integration_test/main.dart --debug --flavor development

pushd ios
xcodebuild clean build build-for-testing \
  -workspace Runner.xcworkspace \
  -scheme development \
  -xcconfig Flutter/Debug.xcconfig \
  -sdk iphoneos \
  -derivedDataPath \
  $output
popd

# https://cloud.google.com/sdk/gcloud/reference/firebase/test/ios

# pushd $product
# zip -r "ios_tests.zip" "Release-iphoneos" "development_iphoneos17.0-arm64.xctestrun"
# popd

# gcloud firebase test ios run \
#   --test "../catalyst_voices/build/ios_integ/Build/Products/ios_tests.zip" \
#   --device model=iphone14pro \
#   --device version=16.6 \
#   --device locale=en_GB \
#   --device orientation=portrait \
#   --timeout 15m \
#   --results-bucket=gs://dev-catalyst-voice.appspot.com \
#   --results-dir=integration_test_results/ios/


  # xcodebuild test-without-building \
  # -xctestrun "../catalyst_voices/build/ios_integ/Build/Products/development_iphoneos17.0-arm64.xctestrun" \
  # -destination id=C666C6C3-26F2-4E26-A0D1-8A3147DDB4A8
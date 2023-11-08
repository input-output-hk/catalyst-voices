#!/bin/bash
set -e

output="../build/ios_integ"
product="build/ios_integ/Build/Products"

pushd catalyst_voices
flutter build ios integration_test/main.dart --debug --flavor development --simulator

pushd ios
xcodebuild build-for-testing \
  -workspace Runner.xcworkspace \
  -scheme development \
  -xcconfig Flutter/Release.xcconfig \
  -configuration Debug-development \
  -sdk iphoneos \
  -derivedDataPath \
  $output
popd

# Varify test build
# xcodebuild test-without-building \
# -xctestrun "../catalyst_voices/build/ios_integ/Build/Products/development_iphoneos17.0-arm64.xctestrun" \
# -destination id=700CAA18-787E-4831-B4D7-6B8E32485304

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "development_iphoneos17.0-arm64.xctestrun"
popd

gcloud firebase test ios run \
  --test "../catalyst_voices/build/ios_integ/Build/Products/ios_tests.zip" \
  --device model=iphone14pro \
  --device version=16.6 \
  --device locale=en_GB \
  --device orientation=portrait \
  --timeout 15m \
  --results-bucket=gs://dev-catalyst-voice.appspot.com \
  --results-dir=integration_test_results/ios/



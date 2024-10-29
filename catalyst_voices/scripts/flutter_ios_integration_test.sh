#!/bin/bash
set -e

output="../build/ios_integ"
product="build/ios_integ/Build/Products"

pushd catalyst_voices
flutter build ios integration_test/main.dart --release --flavor development

pushd ios
xcodebuild -workspace Runner.xcworkspace \
  -allowProvisioningUpdates \
  -scheme development \
  -xcconfig Flutter/Release.xcconfig \
  -configuration Release-development \
  -sdk iphoneos build-for-testing \
  -derivedDataPath $output
popd

## Verify test build locally before pushing to  google cloud.
# xcodebuild test-without-building \
# -xctestrun "../catalyst_voices/build/ios_integ/Build/Products/development_iphoneos17.0-arm64.xctestrun" \
# -destination id=00008120-001934493663C01E

pushd $product
ls
zip -r "ios_tests.zip" "Release-development-iphoneos" "development_iphoneos17.0-arm64.xctestrun"
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



#!/bin/bash
set -e

output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="15.0"

pushd catalyst_voices
flutter build ios integration_test/main.dart --release --flavor development

pushd ios
xcodebuild build-for-testing \
  -workspace Runner.xcworkspace \
  -scheme development \
  -xcconfig Flutter/Release.xcconfig \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath \
  $output
popd

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64.xctestrun"
popd

# gcloud firebase test ios run --test "build/integration_test/Build/Products/ios_tests.zip" \
#   --device-ids=iphone14pro, iphone8 \
#   --os-version-ids=16.6, 15.7 \
#   --locales=en_GB \
#   --orientations=portrait \
#   --timeout 15m \
#   --results-bucket=gs://catalyst_voices_integration_test_results \
#   --results-dir=tests/firebase
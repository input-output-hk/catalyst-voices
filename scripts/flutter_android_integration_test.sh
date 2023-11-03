#!/bin/bash
set -e

pushd catalyst_voices
pushd android
flutter build apk integration_test/main.dart --profile --flavor development
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=integration_test/main.dart
popd

# gcloud firebase test android run --type instrumentation \
#   --app build/app/outputs/apk/debug/app-debug.apk \
#   --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
#   --device-ids=redfin,starqlteue \
#   --os-version-ids=25,30 \
#   --locales=en_GB \
#   --orientations=portrait \
#   --use-orchestrator \
#   --timeout 15m \
#   --results-bucket=gs://catalyst_voices_integration_test_results \
#   --results-dir=tests/firebase

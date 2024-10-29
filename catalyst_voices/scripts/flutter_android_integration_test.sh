#!/bin/bash
set -e

pushd catalyst_voices
flutter build apk integration_test/main.dart --profile --flavor development

pushd android
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=integration_test/main.dart
popd

gcloud firebase test android run --type instrumentation \
  --app ../catalyst_voices/build/app/outputs/apk/development/debug/app-development-debug.apk \
  --test ../catalyst_voices/build/app/outputs/apk/androidTest/development/debug/app-development-debug-androidTest.apk \
  --device-ids=redfin \
  --os-version-ids=30 \
  --locales=en_GB \
  --orientations=portrait \
  --use-orchestrator \
  --timeout 15m \
  --results-bucket=gs://dev-catalyst-voice.appspot.com \
  --results-dir=integration_test_results/android/

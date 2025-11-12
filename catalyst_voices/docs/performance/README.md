# Performance

This document describes how to run performance tests

## Indexing

Launch app using, from [voices](../apps/voices) directory using:

```bash
flutter run --target=lib/configs/main_web.dart \
--device-id=chrome \
--profile \
--wasm \
--dart-define=ENV_NAME=dev \
--dart-define=STRESS_TEST=true \
--dart-define=STRESS_TEST_PROPOSAL_INDEX_COUNT=0 \
--dart-define=STRESS_TEST_DECOMPRESSED=false \
--dart-define=STRESS_TEST_CLEAR_DB=true \
--dart-define=CONSOLE_PROFILE=true \
--web-port=5554 \
--web-header=Cross-Origin-Opener-Policy=same-origin \
--web-header=Cross-Origin-Embedder-Policy=require-corp
```

then open browser developers tools console and gather data.

With updated count of proposals (`STRESS_TEST_PROPOSAL_INDEX_COUNT`).
Be aware that number of produced documents will be higher then number of proposals.

* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=100, `STRESS_TEST_CLEAR_DB`=true
* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=100, `STRESS_TEST_CLEAR_DB`=false
* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=1000, `STRESS_TEST_CLEAR_DB`=true
* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=1000, `STRESS_TEST_CLEAR_DB`=false
* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=2000, `STRESS_TEST_CLEAR_DB`=true
* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=2000, `STRESS_TEST_CLEAR_DB`=false

## Proposals Query

### Machine

Current results are captured on **MacBook Pro, OS Version 15.6.1 (24G90), M1 Pro, 32 GB**.
Measurements from different machines should be in separate .csv files.

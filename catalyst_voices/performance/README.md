# Performance

This document describes how to run performance tests

## Indexing

Launch app using, from [voices](../apps/voices) directory.

```bash
flutter run --target=lib/configs/main_web.dart \
--device-id=chrome \
--profile \
--dart-define=ENV_NAME=dev \
--dart-define=STRESS_TEST=true \
--dart-define=STRESS_TEST_PROPOSAL_INDEX_COUNT=0 \
--web-header=Cross-Origin-Opener-Policy=same-origin \
--web-header=Cross-Origin-Embedder-Policy=require-corp
```

With updated count of proposals (`STRESS_TEST_PROPOSAL_INDEX_COUNT`).
Be aware that number of produced documents will be higher then number of proposals.

* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=100
* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=1000
* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=2000
* `STRESS_TEST_PROPOSAL_INDEX_COUNT`=3000
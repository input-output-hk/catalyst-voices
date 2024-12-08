# catalyst_cardano_example

Demonstrates usage of catalyst_cardano plugin

## To run integration tests

To run test driver you need to have chromedriver installed.

Then in terminal run:

```bash
chromedriver --port=4444
```

In new terminal in example dir run:

```bash
flutter drive --target=test_driver/app.dart \
--web-browser-flag=--disable-web-security \
--web-browser-flag=--disable-gpu \
--web-browser-flag=--disable-search-engine-choice-screen \
--web-header=Cross-Origin-Opener-Policy=same-origin \
--web-header=Cross-Origin-Embedder-Policy=require-corp \
--debug \
--no-headless \
-d web-server --browser-name=chrome --driver-port=4444
```

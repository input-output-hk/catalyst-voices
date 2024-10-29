#!/bin/bash
set -e

# Path to ChromeDriver in Ubuntu image in GitHub Workspace
/usr/local/share/chromedriver-linux64/chromedriver --port=4444 &
# Wait for 5 seconds to allow ChromeDriver to start
sleep 5

cd ./catalyst_voices

flutter drive --driver=test_driver/integration_test.dart \
--target=integration_test/main.dart \
--flavor development \
-d web-server \
--profile --browser-name=chrome
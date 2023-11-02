#!/bin/bash
set -e

git clone https://github.com/flutter/web_installers.git
cd web_installers/packages/web_drivers/
dart pub get

# Run the web driver installer in the background
dart lib/web_driver_installer.dart chromedriver --always-install --driver-version="114.0.5735.90" &
# Wait for 20 seconds to allow the driver installer to complete
sleep 20

chromedriver/chromedriver --port=4444 &
# Wait for 5 seconds to allow ChromeDriver to start
sleep 5

cd ../../../catalyst_voices

flutter drive --driver=test_driver/integration_test.dart \
--target=integration_test/main.dart \
--flavor development \
-d web-server \
--profile --browser-name=chrome
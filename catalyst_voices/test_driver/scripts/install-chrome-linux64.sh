#!/bin/bash
# This script installs Chrome for testing and Chromedriver
echo "TARGET ARCHITECTURE $TARGETARCH"
if [ "$TARGETARCH" == "amd64" ]
then
    PLATFORM=linux64
else
    PLATFORM=mac-arm64
fi

DISTR="Debian 12 (Bookworm)"

# Installing dependencies for Chrome. Workaround for:
# https://github.com/GoogleChromeLabs/chrome-for-testing/issues/55
echo -e "\033[1;34mInstalling Google Chrome dependencies for $PLATFORM"
chrome_deps=$(curl -s https://raw.githubusercontent.com/chromium/chromium/main/chrome/installer/linux/debian/dist_package_versions.json)
deps=$(echo "$chrome_deps" | jq -r ".\"$DISTR\" | keys[]")
apt-get update
for dep in $deps; do
  apt-get install -y $dep
done

# Get latest chrome for testing version
json_chrome=$(curl -s https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json)

# Install chrome
echo -e "\033[1;34mInstalling Google Chrome..."
latest_chrome=$(echo "$json_chrome" | jq -r ".channels.Stable.downloads.chrome[].url | select(contains(\"$PLATFORM\"))")
curl -s --create-dirs -o chrome.zip --output-dir /opt/chrome "$latest_chrome"
unzip -d /opt/chrome -j /opt/chrome/chrome.zip && rm /opt/chrome/chrome.zip
ln -s /opt/chrome/chrome /usr/local/bin/google-chrome
chmod +x /opt/chrome/chrome
google-chrome --version

# Install chromedriver
echo -e "\033[1;34mInstalling Chromedriver..."
latest_chromedriver=$(echo "$json_chrome" | jq -r ".channels.Stable.downloads.chromedriver[].url | select(contains(\"$PLATFORM\"))")
curl -s --create-dirs -o chromedriver.zip --output-dir /opt/chromedriver "$latest_chromedriver"
unzip -d /opt/chromedriver -j /opt/chromedriver/chromedriver.zip && rm /opt/chromedriver/chromedriver.zip
ln -s /opt/chromedriver/chromedriver /usr/local/bin/chromedriver
chmod +x /opt/chromedriver/chromedriver
chromedriver --version

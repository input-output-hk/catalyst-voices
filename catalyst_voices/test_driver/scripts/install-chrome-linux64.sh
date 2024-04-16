#!/bin/bash
# This script installs Chrome/Chromium for testing and Chromedriver
if [ "$TARGETARCH" == "arm64" ]
  # There is no Chrome for testing for arm64, using chromium instead
  # https://github.com/GoogleChromeLabs/chrome-for-testing/issues/1
then
    echo -e "\033[1;34mInstalling Chromium..."
    apt-get update
    apt-get install -y chromium
    ln -s /usr/bin/chromium /usr/local/bin/google-chrome
    google-chrome --version

    apt-get install chromium-driver
    chromedriver --version
else
    DISTR="Debian 12 (Bookworm)"
    # Installing dependencies for Chrome. Workaround for:
    # https://github.com/GoogleChromeLabs/chrome-for-testing/issues/55
    echo -e "\033[1;34mInstalling Google Chrome dependencies..."
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
    latest_chrome=$(echo "$json_chrome" | jq -r ".channels.Stable.downloads.chrome[].url | select(contains(\"linux64\"))")
    curl -s --create-dirs -o chrome.zip --output-dir /opt/chrome "$latest_chrome"
    unzip -d /opt/chrome -j /opt/chrome/chrome.zip && rm /opt/chrome/chrome.zip
    ln -s /opt/chrome/chrome /usr/local/bin/google-chrome
    chmod +x /opt/chrome/chrome
    google-chrome --version

    # Install chromedriver
    echo -e "\033[1;34mInstalling Chromedriver..."
    latest_chromedriver=$(echo "$json_chrome" | jq -r ".channels.Stable.downloads.chromedriver[].url | select(contains(\"linux64\"))")
    curl -s --create-dirs -o chromedriver.zip --output-dir /opt/chromedriver "$latest_chromedriver"
    unzip -d /opt/chromedriver -j /opt/chromedriver/chromedriver.zip && rm /opt/chromedriver/chromedriver.zip
    ln -s /opt/chromedriver/chromedriver /usr/local/bin/chromedriver
    chmod +x /opt/chromedriver/chromedriver
    chromedriver --version
fi
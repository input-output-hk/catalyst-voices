#!/bin/bash
# This script installs Firefox and Geckodriver. Geckodriver supported versions:
# https://firefox-source-docs.mozilla.org/testing/geckodriver/Support.html
# Firefox for linux/arm64 is only in the esr or the unstable version, using the latter

if [ "$TARGETARCH" == "amd64" ]
then
    PLATFORM=linux64
    echo -e "\033[1;34mInstalling Firefox..."
    install -d -m 0755 /etc/apt/keyrings
    curl -fSsL https://packages.mozilla.org/apt/repo-signing-key.gpg | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
    echo '
    Package: *
    Pin: origin packages.mozilla.org
    Pin-Priority: 1000
    ' | tee /etc/apt/preferences.d/mozilla
    apt-get update && apt-get install -y firefox
    firefox --version
else
    PLATFORM=linux-aarch64
    echo -e "\033[1;34mInstalling Firefox..."
    echo "deb http://deb.debian.org/debian/ sid main" >> /etc/apt/sources.list
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131
    apt-get update && apt-get install -y libavcodec-extra firefox
    firefox --version
fi
echo -e "\033[1;34mInstalling Geckodriver..."
json_geckodriver=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest)
latest_geckodriver=$(echo "$json_geckodriver" | jq -r ".assets[].browser_download_url | select(contains(\"$PLATFORM\") and endswith(\"gz\"))")
curl -sL --create-dirs -o geckodriver.tar.gz --output-dir /opt/geckodriver "$latest_geckodriver"
tar -xzf /opt/geckodriver/geckodriver.tar.gz -C /opt/geckodriver/ && rm /opt/geckodriver/geckodriver.tar.gz
ln -s /opt/geckodriver/geckodriver /usr/local/bin/geckodriver
chmod +x /opt/geckodriver/geckodriver
geckodriver --version

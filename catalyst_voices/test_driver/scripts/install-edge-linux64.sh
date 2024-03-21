#!/bin/bash
# This script installs Edge and Edgedriver.
PLATFORM=linux64

echo "Installing Edge..."
install -d -m 0755 /etc/apt/keyrings
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft-edge.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main' | tee /etc/apt/sources.list.d/microsoft-edge.list
apt-get update && apt-get install -y microsoft-edge-stable
microsoft-edge-stable --version

echo "Installing Edgedriver..."
edge_version=$(microsoft-edge-stable --version | grep -Eo '[0-9]+.+' | tr -d ' ')
curl -s --create-dirs -o msedgedriver.zip --output-dir /opt/msedgedriver "https://msedgedriver.azureedge.net/$edge_version/edgedriver_$PLATFORM.zip"
unzip -d /opt/msedgedriver -j /opt/msedgedriver/msedgedriver.zip && rm /opt/msedgedriver/msedgedriver.zip
ln -s /opt/msedgedriver/msedgedriver /usr/local/bin/msedgedriver
chmod +x /opt/msedgedriver/msedgedriver
msedgedriver --version
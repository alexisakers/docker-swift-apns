#!/bin/bash
echo "👉  Installing Swift"
eval "$(curl -sL https://apt.vapor.sh)"
sudo apt-get install swift
sudo chmod -R a+rx /usr/
sudo chmod -R a+rwx /usr/local/

echo "👉  Creating Package"
mkdir docker-swift-apns
mkdir docker-swift-apns/Sources
cp ./.ci/Package.swift docker-swift-apns/Package.swift
cp docker-swift-apns.swift docker-swift-apns/Sources/main.swift
swift build -c release --chdir docker-swift-apns

echo "👉  Installing Build Script"
cp -f docker-swift-apns/.build/release/docker-swift-apns /usr/local/bin/docker-swift-apns
#!/bin/bash
echo "👉  Installing Swift"
SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/ubuntu1404/$SWIFT_VERSION/$SWIFT_VERSION-ubuntu14.04.tar.gz
curl -fSsL $SWIFT_URL -o swift.tar.gz
sudo tar -xzf swift.tar.gz --directory /usr/local --strip-components=2

echo "👉  Compiling Script"
swiftc docker-swift-apns.swift

echo "✅  All dependencies installed successfully"
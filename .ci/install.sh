#!/bin/bash

echo "👉  Installing Swift"
mkdir swift
curl https://swift.org/builds/$SWIFT_VERSION/ubuntu1404/$SWIFT_VERSION/$SWIFT_VERSION-ubuntu14.04.tar.gz | tar xz -C swift &> /dev/null
export PATH=$(pwd)/swift/$SWIFT_VERSION-ubuntu14.04/usr/bin:$PATH

echo "👉  Installing Marathon"
git clone git@github.com:JohnSundell/Marathon.git
cd Marathon
swift build -c release
cp -f .build/release/Marathon /usr/local/bin/marathon

echo "👉  Installing Build Script"
marathon install docker-swift-apns /usr/local/docker-swift-apns
#!/bin/bash

echo "👉  Installing Swift"
eval "$(curl -sL https://apt.vapor.sh)"
sudo apt-get install swift
sudo chmod -R a+rx /usr/

echo "👉  Installing Marathon"
git clone https://github.com/JohnSundell/Marathon.git
cd Marathon
swift build -c release
cp -f .build/release/Marathon /usr/local/bin/marathon

echo "👉  Installing Build Script"
marathon install docker-swift-apns /usr/local/docker-swift-apns
#!/bin/bash

echo "👉  Installing Swift"
eval "$(curl -sL https://apt.vapor.sh)"
sudo apt-get install swift
sudo chmod -R a+rx /usr/

echo "👉  Installing Marathon"
git clone https://github.com/JohnSundell/Marathon.git 
cd Marathon
sed -i -e "s/git@github.com:johnsundell/https:\/\/github.com\/johnsundell/g" Package.swift
swift build -c release
cp -f .build/release/Marathon /usr/local/bin/marathon

echo "👉  Installing Build Script"
mv Marathonfile Marathonfile.bak
marathon install https://raw.githubusercontent.com/JohnSundell/Files/master/Sources/Files.swift
marathon install docker-swift-apns /usr/local/docker-swift-apns
// swift-tools-version:3.0

import PackageDescription

let package = Package(
    name: "ImageTools",
    dependencies: [
        .Package(url: "https://github.com/boostcode/CCurl.git", majorVersion: 0, minor: 2)
    ]
)

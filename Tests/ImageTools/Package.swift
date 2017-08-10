// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ImageTools",
    dependencies: [
        .package(url: "https://github.com/boostcode/CCurl.git", from: "0.2.0")
    ],
    targets: [
        .target(name: "ImageTools"),
        .testTarget(name: "ImageTests", dependencies: ["ImageTools"])
    ]
)

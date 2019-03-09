// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ImageTools",
    products: [
        .library(
            name: "ImageTools",
            targets: ["ImageTools"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/CCurl", from: "1.0.0")
    ],
    targets: [
        .target(name: "ImageTools", dependencies: ["CCurl"]),
        .testTarget(name: "ImageToolsTests", dependencies: ["ImageTools"]),
    ]
)

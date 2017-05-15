// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "TestSuite",
    dependencies: [
        .Package(url: "https://github.com/JohnSundell/ShellOut.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/boostcode/CCurl.git", majorVersion: 0, minor: 2)
    ]
)

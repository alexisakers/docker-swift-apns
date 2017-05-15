import PackageDescription

let package = Package(
    name: "docker-swift-apns",
    dependencies: [
        .Package(url: "https://github.com/JohnSundell/Files.git", majorVersion: 1, minor: 8)
    ]
)
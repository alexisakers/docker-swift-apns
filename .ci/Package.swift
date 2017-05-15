import PackageDescrition

let package = Package(
    name: "dsa",
    dependencies: [
        .Package(url: "https://github.com/JohnSundell/Files.git", majorVersion: 1, minor: 8)
    ]
)